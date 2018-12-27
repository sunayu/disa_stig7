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
#{% from "disa_stig7/map.jinja" import disa_stig7 with context %}

#include:
#  - disa_stig7.auditd

#CAT2
### RHEL-07-030010
### RHEL-07-020320

# CAT2
# RHEL-07-020320
#CAT2 RHEL-07-02320 unowned.files
#  cmd.run:

# CAT2
# RHEL-07-030010
#CAT2 RHEL-07-030010 audit.rules:
#  cmd.run:
#    - name: auditctl -f 2
# file.append:
#   - name: /etc/audit/rules.d/audit.rules
#   - text:
#     - "-f 2"
#   - watch_in:
#     - cmd: auditd service restart

#{% endif %}
