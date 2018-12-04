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

#CAT1
#RHEL-07-010010
CAT1 RHEL-07-010010 address rpm default mode,user,group permissions:
 disa_stig7.enforce_rpm_attributes: []

# CAT1
# RHEL-07-010290
CAT1 RHEL-07-010290 remove nullok from system-auth:
  file.replace:
  - name: /etc/pam.d/system-auth 
  - pattern: "nullok "
  - repl: ""
  
# CAT1
# RHEL-07-010290
CAT1 RHEL-07-010290 remove nullok from password-auth:
  file.replace:
  - name: /etc/pam.d/password-auth 
  - pattern: "nullok "
  - repl: ""

# CAT1
# RHEL-07-020000
CAT1 RHEL-07-020000 remove rsh-server:
  pkg.removed:
  - name: rsh-server

# CAT1
# RHEL-07-020010
CAT1 RHEL-07-020010 remove ypserv:
  pkg.removed:
  - name: ypserv

# CAT1
# RHEL-07-020050
CAT1 RHEL-07-020050 gpgcheck yum:
  file.replace:
  - name: /etc/yum.conf
  - pattern: |
      ^\s*gpgcheck\s*=.+$
  - repl: |
      gpgcheck=1
  - append_if_not_found: true

# CAT1
# RHEL-07-020060
CAT1 RHEL-07-020060 localpkg_gpgcheck yum:
  file.replace:
  - name: /etc/yum.conf
  - pattern: 
      ^\s*localpkg_gpgcheck\s*=.+\n
  - repl: "localpkg_gpgcheck=1\n"
  - not_found_content: "localpkg_gpgcheck=1"
  - append_if_not_found: true

# CAT1
# RHEL-07-020210
CAT1 RHEL-07-020210 selinux enforcing:
  selinux.mode:
  - name: enforcing

# CAT1
# RHEL-07-020220
CAT1 RHEL-07-020220 selinux type targetted:
  file.replace:
  - name: /etc/selinux/config
  - pattern: |
      ^SELINUXTYPE=.+$
  - repl: "SELINUXTYPE=targeted\n"
  - not_found_content: "SELINUXTYPE=targeted"
  - append_if_not_found: true

# CAT1
# RHEL-07-021710
CAT1 RHEL-07-021710 remove telnet-server:
  pkg.removed:
  - name: telnet-server

# CAT1
# RHEL-07-040690
CAT1 RHEL-07-040690 remove vsftpd:
  pkg.removed:
  - name: vsftpd

# CAT1
# RHEL-07-040490
CAT1 RHEL-07-040490 remove lftpd:
  pkg.removed:
  - name: lftpd

# CAT1
# RHEL-07-040700
CAT1 RHEL-07-040700 remove tftp-server:
  pkg.removed:
  - name: tftp-server

# CAT1
# RHEL-07-040500
CAT1 RHEL-07-040500 remove tftp:
  pkg.removed:
  - name: tftp

{% set snmpdconf = salt['file.file_exists']('/etc/snmp/snmpd.conf') %}
{% if snmpdconf %}
{% set snmpd_service_status = salt['service.status']('snmpd') %}
# CAT1
# RHEL-07-040800
CAT1 RHEL-07-040800 snmp remove public:
  file.replace:
  - name: /etc/snmp/snmpd.conf
  - pattern: 'public'
  - repl: 'notpub'
{%   if snmpd_service_status %}
  - watch_in:
    - service: snmpd service restart
{%   endif %}
{%   if snmpd_service_status %}
snmpd service restart:
  service.running:
  - name: snmpd
{%   endif %}
{% endif %}

{% set gdm_version = salt['pkg.version']('gdm') %}
{% if gdm_version %}
install python-augeas pkg:
  pkg.installed:
  - name: python-augeas

# CAT1
# RHEL-07-010440
CAT1 RHEL-07-010440 gdm AutomaticLoginEnable false:
  augeas.change:
  - context: /files/etc/gdm/custom.conf
  - changes:
    - set daemon/AutomaticLoginEnable false

# CAT1
# RHEL-07-010450
CAT1 RHEL-07-010450 gdm TimedLoginEnable false:
  augeas.change:
  - context: /files/etc/gdm/custom.conf
  - changes:
    - set daemon/TimedLoginEnable false
{% endif %}

# CAT1
# RHEL-07-020230
CAT1 RHEL-07-020230 disable ctrl-alt-del:
  file.symlink:
  - name: /etc/systemd/system/ctrl-alt-del.target
  - target: /dev/null

{% set dconf_version = salt['pkg.version']('dconf') %}
{% if dconf_version %}
CAT1 RHEL-07-020230 gnome disable ctrl-alt-del:
  file.managed:
  - name: /etc/dconf/db/local.d/00-disable-CAD
  - contents:
    - "[org/gnome/settings-daemon/plugins/media-keys]"
    - "logout=''"
{% endif %}

# CAT1
# RHEL-07-010460
# RHEL-07-010470

include:
  - disa_stig7.grub

{% if salt['file.file_exists']('/boot/efi/EFI/centos/grub.cfg') %}
{% set grub_user_file = '/boot/efi/EFI/centos/user.cfg' %}
{% else %}
{% set grub_user_file = '/boot/grub2/user.cfg' %}
{% endif %}

# RHEL-07-010480
# RHEL-07-010490
CAT1 RHEL-07-010480 grub password:
  file.append:
  - name: /etc/grub.d/40_custom
  - text:
    - 'set superusers="root"'
    - 'password_pbkdf2 root {{ disa_stig7.grub_root_password }}'
  - watch_in:
    - cmd: grub-mkconfig

