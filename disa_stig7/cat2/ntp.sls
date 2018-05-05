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

# CAT2
# RHEL-07-040500
ntp pkg:
  pkg.installed:
  - name: ntp

CAT2 RHEL-07-040210 ntp.conf maxpoll:
  file.replace:
  - name: /etc/ntp.conf
  - pattern: |
      ^(server((?!maxpoll).)*)$
  - repl: '\1 maxpoll 10\n'
  - append_if_not_found: false
  - watch_in:
    - service: ntpd service

ntpd service:
  service.running:
  - name: ntpd
  - enable: true
