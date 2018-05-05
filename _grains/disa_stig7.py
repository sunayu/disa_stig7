#!/usr/bin/env python
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

from subprocess import Popen, PIPE
import os

def _find_boot_dev():
    output = Popen(['df','/boot'], stdout=PIPE)
    boot_device = output.stdout.read().split('\n')[1].split()[0]
    return boot_device

def _find_root_dev():
    output_root = Popen(['df','/'], stdout=PIPE)
    root_device = output_root.stdout.read().split('\n')[1].split()[0]
    return root_device

def main():
    # initialize a grains dictionary
    grains = {}

    device = False
    space_left = False

    if os.path.isdir('/var/log/audit'):

        process = Popen(['df','--block-size=1M','/var/log/audit'], stdout=PIPE)
        output = process.communicate()
        exit_code = process.wait()

        if exit_code == 0:
            cmd_data = output[0].split('\n')
  
            if len(cmd_data[1].split()) == 1:
                device = cmd_data[1].split()[0]
                space_left = int(int(cmd_data[2].split()[0]) * 0.25)
            else:
                device = cmd_data[1].split()[0]
                space_left = int(int(cmd_data[1].split()[1]) * 0.25)

    grains['stig_audit_device'] = device
    grains['stig_audit_space_left'] = space_left

    grains['stig_boot_device'] = _find_boot_dev()
    grains['stig_root_device'] = _find_root_dev()
 
    return grains

