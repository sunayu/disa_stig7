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
{% from "disa_stig7/sysctl.sls" import set_sysctl_conf %}

include:
  - disa_stig7.sysctl

# CAT2
# RHEL-07-040610
{{ set_sysctl_conf('CAT2','RHEL-07-040610','net.ipv4.conf.all.accept_source_route','0') }}

# CAT2
# RHEL-07-040620
{{ set_sysctl_conf('CAT2','RHEL-07-040620','net.ipv4.conf.default.accept_source_route','0') }}

# CAT2
# RHEL-07-040630
{{ set_sysctl_conf('CAT2','RHEL-07-040630','net.ipv4.icmp_echo_ignore_broadcasts','1') }}

# CAT2
# RHEL-07-040641
{{ set_sysctl_conf('CAT2','RHEL-07-040641','net.ipv4.conf.all.accept_redirects','0') }}

# CAT2
# RHEL-07-040640
{{ set_sysctl_conf('CAT2','RHEL-07-040640','net.ipv4.conf.default.accept_redirects','0') }}

# CAT2
# RHEL-07-040650
{{ set_sysctl_conf('CAT2','RHEL-07-040650','net.ipv4.conf.default.send_redirects','0') }}

# CAT2
# RHEL-07-040660
{{ set_sysctl_conf('CAT2','RHEL-07-040421','net.ipv4.conf.all.send_redirects','0') }}

# CAT2
# RHEL-07-040740
{{ set_sysctl_conf('CAT2','RHEL-07-040740','net.ipv4.ip_forward','0') }}

# CAT2
# RHEL-07-040830
{{ set_sysctl_conf('CAT2','RHEL-07-040830','net.ipv6.conf.all.accept_source_route','0') }}

# CAT2
# RHEL-07-040201
{{ set_sysctl_conf('CAT2','RHEL-07-040201','kernel.randomize_va_space','2') }}

# Other?
{{ set_sysctl_conf('CAT2','na','kernel.dmesg_restrict','1') }}
