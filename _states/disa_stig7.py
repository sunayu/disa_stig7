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

import salt.exceptions

def enforce_rpm_attributes(name):
    '''
    Enforce the mode, owner, and group permissions of files associated with rpms

    This state module calls a custom disa_stig7 module in order to check the current
    system and perform any needed changes.

    Requires:
    * disa_stig7 execution module

    Example usage:

      Enforce rpm mode,owner,group attributes:
        disa_stig7.enforce_rpm_attributes: []

    '''
    ret = {
        'name': name,
        'changes': {},
        'result': False,
        'comment': '',
        'changes': {},
        }

    # See if we need to change anything
    current_state = __salt__['disa_stig7.get_files']()

    if 'file_issues' in current_state:
        files = current_state
    else:
        ret['result'] = True
        ret['comment'] = 'Attributes for rpm packages are already in the correct state'

        return ret

    # Handle test=true
    if __opts__['test'] == True:
        ret['comment'] = 'Attributes for the following files will be reset.'
        ret['changes'] = {
            'old': None,
            'new': files
        }
        ret['result'] = None

        return ret

    # Finally, make the actual change and return the result.
    new_state = __salt__['disa_stig7.reset_files'](files)

    del new_state['file_issues']

    ret['comment'] = 'Attributes for rpms have been reset!'.format(name)
    ret['changes'] = {
        'old': current_state,
        'new': new_state,
    }
    ret['result'] = True

    return ret
