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

{% set dconf_version = salt['pkg.version']('dconf') %}
{% if dconf_version %}
# CAT2
# RHEL-07-010040
# RHEL-07-010030
CAT2 RHEL-07-010040 dconf enable banner:
  file.managed:
  - name: /etc/dconf/db/local.d/01-banner-message
  - source: salt://disa_stig7/files/cat2/01-banner-message.j2
  - template: jinja
  - context:
      login_message_banner: {{ disa_stig7.login_message_banner }}
  - watch_in:
    - cmd: update dconf

# CAT2
# RHEL-07-010060
# RHEL-07-010061
# RHEL-07-010062
# RHEL-07-010070
# RHEL-07-010081
# RHEL-07-010082
# RHEL-07-010100
# RHEL-07-010101
# RHEL-07-010110
CAT2 RHEL-07-010060 dconf screensaver lock:
  file.managed:
  - name: /etc/dconf/db/local.d/00-security-settings
  - source: salt://disa_stig7/files/cat2/00-security.j2
  - watch_in:
    - cmd: update dconf

CAT2 RHEL-07-010071 dconf session lock:
  file.managed:
  - name: /etc/dconf/db/local.d/locks/00-security-settings-lock
  - contents:
    - '/org/gnome/desktop/screensaver/idle-delay'
    - '/org/gnome/desktop/screensaver/lock-delay'
    - '/org/gnome/desktop/screensaver/lock-enabled'
    - '/org/gnome/desktop/screensaver/idle-activation-enabled'
    - '/org/gnome/desktop/session/idle-delay'
    - '/org/gnome/settings-daemon/plugins/media-keys/logout'
  - watch_in:
    - cmd: update dconf

update dconf:
  cmd.wait:
  - name: dconf update

{% endif %}

# CAT2
# RHEL-07-010050
CAT2 RHEL-07-010050 etc issue:
  file.managed:
  - name: /etc/issue
  - contents: {{ disa_stig7.login_message_banner }}

# CAT2
# RHEL-07-010090 
CAT2 RHEL-07-010072 install screen:
  pkg.installed:
  - name: screen

# CAT2
# RHEL-07-010090
CAT2 RHEL-07-010090 pwquality ucredit:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^ucredit\s*=.+$
  - repl: 'ucredit = -1\n'
  - not_found_content: 'ucredit = -1'
  - append_if_not_found: true

# CAT2
# RHEL-07-010130
CAT2 RHEL-07-010130 pwquality lcredit:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^lcredit\s*=.+$
  - repl: 'lcredit = -1\n'
  - not_found_content: 'lcredit = -1'
  - append_if_not_found: true

# CAT2
# RHEL-07-010140
CAT2 RHEL-07-010140 pwquality dcredit:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^dcredit\s*=.+$
  - repl: 'dcredit = -1\n'
  - not_found_content: 'dcredit = -1'
  - append_if_not_found: true

# CAT2
# RHEL-07-010150
CAT2 RHEL-07-010150 pwquality ocredit:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^ocredit\s*=.+$
  - repl: 'ocredit = -1\n'
  - not_found_content: 'ocredit = -1'
  - append_if_not_found: true

# CAT2
# RHEL-07-010160
CAT2 RHEL-07-010160 pwquality difok:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^difok\s*=.+$
  - repl: 'difok = 8\n'
  - not_found_content: 'difok = 8'
  - append_if_not_found: true

# CAT2
# RHEL-07-010170
CAT2 RHEL-07-010170 pwquality minclass:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^minclass\s*=.+$
  - repl: 'minclass = 4\n'
  - not_found_content: 'minclass = 4'
  - append_if_not_found: true

# CAT2
# RHEL-07-010180
CAT2 RHEL-07-010180 pwquality maxrepeat:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^maxrepeat\s*=.+$
  - repl: 'maxrepeat = 2\n'
  - not_found_content: 'maxrepeat = 2'
  - append_if_not_found: true

# CAT2
# RHEL-07-010190
CAT2 RHEL-07-010190 pwquality maxclassrepeat:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^maxclassrepeat\s*=.+$
  - repl: 'maxclassrepeat = 2\n'
  - not_found_content: 'maxclassrepeat = 2'
  - append_if_not_found: true

# CAT2
# RHEL-07-010250
CAT2 RHEL-07-010250 pwquality minlen:
  file.replace:
  - name: /etc/security/pwquality.conf
  - pattern: |
      ^minlen\s*=.+$
  - repl: 'minlen = 15\n'
  - not_found_content: 'minlen = 15'
  - append_if_not_found: true

# CAT2
# RHEL-07-010210
CAT2 RHEL-07-010210 login.defs ENCRYPT_METHOD:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^ENCRYPT_METHOD.+$
  - repl: 'ENCRYPT_METHOD SHA512\n'
  - not_found_content: 'ENCRYPT_METHOD SHA512'
  - append_if_not_found: true

# CAT2
# RHEL-07-010230
CAT2 RHEL-07-010230 login.defs PASS_MIN_DAYS:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^PASS_MIN_DAYS.+$
  - repl: 'PASS_MIN_DAYS 1\n'
  - not_found_content: 'PASS_MIN_DAYS 1'
  - append_if_not_found: true

# CAT2
CAT2 login.defs PASS_MAX_DAYS:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^PASS_MAX_DAYS.+$
  - repl: 'PASS_MAX_DAYS {{ disa_stig7.pass_max_days }}\n'
  - not_found_content: 'PASS_MAX_DAYS {{ disa_stig7.pass_max_days }}'
  - append_if_not_found: true

# CAT2
# RHEL-07-010420
CAT2 RHEL-07-010420 login.defs FAIL_DELAY:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^FAIL_DELAY.+$
  - repl: 'FAIL_DELAY 4\n'
  - not_found_content: 'FAIL_DELAY 4'
  - append_if_not_found: true

# CAT2
# RHEL-07-010481
CAT2 RHEL-07-010481 single_user_mode authentication:
  file.replace:
  - name: /usr/lib/systemd/system/rescue.service
  - pattern: |
      ^ExecStart=-\/bin\/sh\s*-c\s*\"/usr/bin/systemctl\s*--fail.+$
  - repl: "ExecStart=-/bin/sh -c \"/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default\n"
  - append_if_not_found: false

# CAT2
# RHEL-07-020230
CAT2 RHEL-07-020230 login.defs UMASK:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^UMASK.+$
  - repl: 'UMASK 077\n'
  - not_found_content: 'UMASK 077'
  - append_if_not_found: true

# CAT2
# RHEL-07-020630
CAT2 RHEL-07-020630 login.defs CREATE_HOME:
  file.replace:
  - name: /etc/login.defs
  - pattern: |
      ^CREATE_HOME.+$
  - repl: 'CREATE_HOME yes\n'
  - not_found_content: 'CREATE_HOME yes'
  - append_if_not_found: true

# CAT2
# RHEL-07-010280
CAT2 RHEL-07-010280 useradd INACTIVE:
  file.replace:
  - name: /etc/default/useradd
  - pattern: |
      ^INACTIVE\s*=.+$
  - repl: 'INACTIVE=0\n'
  - not_found_content: 'INACTIVE=0'
  - append_if_not_found: true

#CAT2
#RHEL-07-010380
CAT2 RHEL-07-010380 sudoers NOPASSWD:
   file.replace:
   - name: /etc/sudoers
   - pattern: |
       ^(.+)NOPASSWD:\s+(.+)$
   - repl: |
       \1\2
# CAT2
# RHEL-07-010220
# TODO: This does not ensure the value is set in the default setting. Prob need augeas?
CAT2 RHEL-07-010220 libuser crypt_style:
  file.replace:
  - name: /etc/libuser.conf
  - pattern: |
      ^crypt_style\s*=.+$
  - repl: 'crypt_style = sha512\n'
  - not_found_content: 'crypt_style = sha512'
  - append_if_not_found: true

# CAT2
# RHEL-07-020160
CAT2 RHEL-07-020160 modprobe.d disable usb-storage:
  file.managed:
  - name: /etc/modprobe.d/disable-usb-storage.conf
  - contents: install usb-storage /bin/true 

# ?
modprobe.d disable bluetooth:
  file.managed:
  - name: /etc/modprobe.d/disable-bluetooth.conf
  - contents: install bluetooth /bin/true

# RHEL-07-020101
CAT2 RHEL-07-020101 modprobe disable dccp:
  file.managed:
  - name: /etc/modprobe.d/disable-dccp.conf
  - contents: install dccp /bin/true

# CAT2
# RHEL-07-020161
{% set autofs_service_status = salt['service.available']('autofs') %}
{% if autofs_service_status %}
CAT2 RHEL-07-020161 disable autofs service:
  service.dead:
  - name: autofs
  - enable: false
{% endif %}

# CAT2
# RHEL-07-020290
CAT2 RHEL-07-020290 no games account in passwd:
 file.line:
   - name: /etc/passwd
   - match: games
   - mode: delete

# CAT2
# RHEL-07-020290
CAT2 RHEL-07-020290 no gopher account in passwd:
 file.line:
   - name: /etc/passwd
   - match: gopher
   - mode: delete

# CAT2
# RHEL-07-021230
{% set kdump_service_status = salt['service.available']('kdump') %}
{% if kdump_service_status %}
CAT2 RHEL-07-021230 disable kdump service:
  service.dead:
  - name: kdump
  - enable: false
{% endif %}

# CAT2
# RHEL-07-021190
# RHEL-07-021200
CAT2 RHEL-07-021190 cron.allow:
  file.managed:
  - name: /etc/cron.allow
  - user: root
  - group: root
  - mode: 0600
  - replace: False

# CAT2
# RHEL-07-040160
CAT2 RHEL-07-040160 etc profile TMOUT:
  file.replace:
  - name: /etc/profile
  - pattern: |
      ^TMOUT\s*=.+$
  - repl: 'TMOUT=600\n'
  - not_found_content: 'TMOUT=600'
  - append_if_not_found: true

# CAT2
# RHEL-07-010200
# RHEL-07-010330
CAT2 pam.d system-auth:
  file.managed:
  - name: /etc/pam.d/system-auth
  - source: salt://disa_stig7/files/cat2/system-auth.j2
  - template: jinja
  - context:
      password_remember: {{ disa_stig7.password_remember }}

# CAT2
# RHEL-07-010330
# RHEL-07-010371
# RHEL-07-010372
# RHEL-07-010373
CAT2 pam.d password-auth:
  file.managed:
  - name: /etc/pam.d/password-auth
  - source: salt://disa_stig7/files/cat2/system-auth.j2
  - template: jinja
  - context:
      password_remember: {{ disa_stig7.password_remember }}

# CAT2
# RHEL-07-040820
#CAT2 RHEL-07-040820 libswanpkg remove:
#  pkg.purged:
#  - name: libreswan

{% set postfix_version = salt['pkg.version']('postfix') %}
{% if postfix_version %}
# CAT2
# RHEL-07-040680
CAT2 RHEL-07-040680 postfix smtpd_client_restrictions:
  file.replace:
  - name: /etc/postfix/main.cf 
  - pattern: |
      ^smtpd_client_restrictions\s*=.+$
  - repl: "smtpd_client_restrictions = permit_mynetworks, reject\n"
  - not_found_content: "smtpd_client_restrictions = permit_mynetworks, reject"
  - append_if_not_found: true
  - watch_in:
    - service: restart postfix

restart postfix:
  service.running:
  - name: postfix
{% endif %}

{% set tftp_server_version = salt['pkg.version']('tftp-server') %}
{% if tftp_server_version %}
# CAT2
# RHEL-07-040720
CAT2 RHEL-07-040720 tftp-server server_args:
  file.replace:
  - name: /etc/xinetd.d/tftp
  - pattern: |
      ^server_args\s*=.+$
  - repl: "server_args = -s /var/lib/tftpboot\n"
{% endif %}

{% set libreswan_version = salt['pkg.version']('libreswan-server') %}
{% if libreswan_version %}
# CAT2
# RHEL-07-040820
CAT2 RHEL-07-040720 libreswan ipsec:
  file.comment:
  - name: /etc/ipsec.conf
  - pattern: |
      ^conn.+$
  - repl: "#conn"
{% endif %}

{% set libreswan_version = salt['pkg.version']('libreswan-server') %}
{% if libreswan_version %}
# CAT2
# RHEL-07-040820
CAT2 RHEL-07-040820 :
  file.comment:
  - name: /etc/ipsec.d/*.conf
  - pattern: |
      ^conn.+$
  - repl: "#conn"
{% endif %}

# RHEL-07-041001
CAT2 RHEL-07-041001 pkgs for multifactor auth:
  pkg.installed:
  - pkgs:
    - esc
    - pam_pkcs11
    - authconfig-gtk

# CAT2
# RHEL-07-040040
CAT2 RHEL-07-040030 pam_pkcs11.conf use_pkcs11_module:
  file.replace:
  - name: /etc/pam_pkcs11/pam_pkcs11.conf
  - pattern: |
      use_pkcs11_module\s*=.+$
  - repl: 'use_pkcs11_module = cackey;\n'

# CAT2
# RHEL-07-040050
CAT2 RHEL-07-040050 pam_pkcs11 subject_mapping:
  file.managed:
  - name: /etc/pam_pkcs11/subject_mapping
  - replace: False

# CAT2
# RHEL-07-040060
# RHEL-07-040070
# RHEL-07-040080
CAT2 RHEL-07-040060 pam_pkcs11 cn_map:
  file.managed:
  - name: /etc/pam_pkcs11/cn_map
  - user: root
  - group: root
  - mode: 0644
  - replace: False

# RHEL-07-041003
CAT2 RHEL-07-041003 pam_pkcs11 must impliment ocsp:
  file.replace:
  - name: /etc/pam_pkcs11/pam_pkcs11.conf
  - pattern: |
      ^\s+?cert_policy\s*=.+$
  - repl: "cert_policy = ca, ocsp_on, signature;\n"
  - append_if_not_found: false

# RHEL-07-010119
CAT2 RHEL-07-010119 pam.d password pwquality:
  file.replace:
  - name: /etc/pam.d/passwd
  - pattern: |
      ^password\s+required\+pam_pwquality.so.+$
  - repl: "password required pam_pwquality.so retry=3\n"
  - not_found_content: "password required pam_pwquality.so retry=3"
  - prepend_if_not_found: true
