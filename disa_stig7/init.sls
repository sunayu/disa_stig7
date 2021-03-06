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
{% from "disa_stig7/map.jinja" import disa_stig7 with context %}
include:
  - .cat1.auditd
  - .cat1.clamav
  - .cat1.fips
  - .cat1.sshd
  - .cat1.system
  - .cat2.aide
  - .cat2.auditd
{% if disa_stig7.enable_iptables %}
  - .cat2.iptables
{% endif %}
  - .cat2.ntp
  - .cat2.rsyslog
  - .cat2.sshd
  - .cat2.sssd
  - .cat2.sysctl
  - .cat2.system
  - .cat3.sshd
  - .cat3.system
