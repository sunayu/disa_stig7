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
# RHEL-07-040300
CAT2 RHEL-07-040300 openssh-server pkg:
  pkg.installed:
  - name: openssh-server

CAT2 RHEL-07-040300 openssh-clients pkg:
  pkg.installed:
  - name: openssh-clients

# CAT2
# RHEL-07-040310
sshd service:
  service.running:
  - name: sshd
  - enable: true

{% macro set_sshd_conf (cat, stig_id, key, value) -%}
{{ cat }} {{ stig_id }} sshd {{ key }}:
  file.replace:
  - name: /etc/ssh/sshd_config
  - pattern: |
      ^{{ key }}\s+.+$
  - repl: "{{ key }} {{ value }}\n"
  - not_found_content: "{{ key }} {{ value }}"
  - append_if_not_found: true
  - watch_in:
    - service: sshd service
{%- endmacro %}
