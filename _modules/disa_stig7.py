#   Copyright [2018] [Sunayu LLC]
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

import logging
import re

'''
  This execution module is used to find files with differing mode, user, and/or group from
  their rpm packages and reset them. Two public commands are defined:

  disa_stig7.get_files

  This will just list files identified as having differing mode, user, or group from their rpm package.

  disa_stig7.reset_files

  This will first identify files identified as having differeing mode, user, or group from their rpm
  package then reset them.
'''

log = logging.getLogger(__name__)

def _get_rpm_output():
    cmd_output = __salt__['cmd.run_all']('rpm -Va', ignore_retcode=True)
    return cmd_output

def get_files():
    ret = {}

    cmd_output = _get_rpm_output()
    stdout = cmd_output['stdout']
    lines = stdout.split('\n')

    owner_files = []
    group_files = []
    mode_files = []

    for line in lines:
        match = re.search(r'^.(.).{3}(.)(.).+?(/.+)', line)
        if match:                     
            mode = match.group(1)
            owner = match.group(2)
            group = match.group(3)
            myfile = match.group(4)

            if mode == 'M':
                mode_files.append(myfile)
                log.info('File: ' + myfile + ' has a differing mode')

            if owner == 'U':
                owner_files.append(myfile)
                log.info('File: ' + myfile + ' has a differing user')

            if group == 'G':
                group_files.append(myfile)
                log.info('File: ' + myfile + ' has a differing group')

    if owner_files or mode_files or group_files:
        ret['file_issues'] = {}
        if owner_files:
            ret['file_issues']['owner'] = list(set(owner_files))

        if mode_files:
            ret['file_issues']['mode'] = list(set(mode_files))

        if group_files:
            ret['file_issues']['group'] = list(set(group_files))
    else:
        return 'No issues found!'

    return ret

file_pkg_lookup = {}

def _get_files_pkg(files):
    pkgs = []

    for f in files:

        if f in file_pkg_lookup:
            log.info('Using cache to match ' + f + ' with ' + file_pkg_lookup[f])
            pkgs.append(file_pkg_lookup[f])
        else:
            log.info('Looking up package for ' + f)
            cmd = 'rpm -qf ' + f
            cmd_out = __salt__['cmd.run'](cmd)
            for line in cmd_out.split('\n'):
                match = re.search(r'^(.+?)-\d.+', line)
                if match:
                    pkg_name = match.group(1)
                    pkgs.append(pkg_name)
                    file_pkg_lookup[f] = pkg_name

    # remove duplicates from our list
    return list(set(pkgs))
 
def reset_files(files_with_issues=None):
    ret = 'No files need to be reset.'

    mpkgs = []
    opkgs = []
    gpkgs = []

    if files_with_issues:
        files = files_with_issues
    else:
        files = get_files()

    if 'file_issues' in files:
        ret = {}
        file_issues = files['file_issues']
        ret['file_issues'] = file_issues

        if 'mode' in file_issues:
            mpkgs = _get_files_pkg(file_issues['mode'])

        if 'owner' in file_issues:
            opkgs = _get_files_pkg(file_issues['owner'])

        if 'group' in file_issues:
            gpkgs = _get_files_pkg(file_issues['group'])

    if mpkgs:
        ret['rpms_mode_reset'] = mpkgs
        for pkg in mpkgs:
            mode_cmd = 'rpm --setperms ' + pkg
            mode_cmd_out = __salt__['cmd.run_all'](mode_cmd)
            if mode_cmd_out['retcode'] != 0:
                log.error(mode_cmd_out)

    # Since owner/group is the same command we remove duplicates and run them together
    if opkgs or gpkgs:
        ogpkgs = list(set(opkgs + gpkgs))
        ret['rpms_owner_group_reset'] = ogpkgs
        for pkg in ogpkgs:
            og_cmd = 'rpm --setugids ' + pkg
            og_cmd_out = __salt__['cmd.run_all'](og_cmd)
            if og_cmd_out['retcode'] != 0:
                log.error(og_cmd_out)

    return ret

def _get_root_users_output():
    cmd_output = __salt__['cmd.run_all']("awk -F: '$3 == 0 {print $1}' \/etc\/passwd", ignore_retcode=True)
    return cmd_output

def get_users():
    retusers = []

    cmd_output = _get_root_users_output()
    stdout = cmd_output['stdout']
    lines = stdout.split('\n')

    for line in lines:
        retusers.append(line)
    return retusers

def find_bad_users():
    bad_users = {} 
    retusers = get_users()
    user_list = []

    for user in retusers:
        if user == 'root' and len(retusers) == 1:
            user_list.append('None')
        elif user != 'root':
            user_list.append(user) 
    bad_users['duplicate_users'] = user_list 

    return bad_users
