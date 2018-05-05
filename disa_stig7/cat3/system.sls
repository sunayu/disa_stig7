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

# CAT3
# # RHEL-07-010490
CAT2 RHEL-07-010490 no unnecessary geoclue account in passwd:
  file.line:
  - name: /etc/passwd
  - match: geoclue 
  - mode: delete

# CAT3
# RHEL-07-010490
CAT2 RHEL-07-010490 no unnecessary ftp account in passwd:
  file.line:
  - name: /etc/passwd
  - match: ftp 
  - mode: delete

# CAT3
# RHEL-07-020200
CAT3 RHEL-07-020200 yum clean_requirements_on_remove:
  file.replace:
  - name: /etc/yum.conf
  - pattern: |
      ^\s*clean_requirements_on_remove\s*=.+$
  - repl: "clean_requirements_on_remove=1\n"
  - not_found_content: "clean_requirements_on_remove=1"
  - append_if_not_found: true

# CAT3
# RHEL-07-040000
CAT3 RHEL-07-040000 limits.conf limit 10 logins:
  file.replace:
  - name: /etc/security/limits.conf
  - pattern: |
      ^\*\s+hard\s+maxlogins.+$
  - repl: "* hard maxlogins 10\n"
  - not_found_content: "* hard maxlogins 10"
  - append_if_not_found: true

