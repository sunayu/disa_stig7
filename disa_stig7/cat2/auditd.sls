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
  - disa_stig7.auditd

# CAT2
# RHEL-07-030090
# RHEL-07-030310
# RHEL-07-030380
# RHEL-07-030381
# RHEL-07-030382
# RHEL-07-030383
# RHEL-07-030390
# RHEL-07-030391
# RHEL-07-030392
# RHEL-07-030400
# RHEL-07-030401
# RHEL-07-030402
# RHEL-07-030403
# RHEL-07-030404
# RHEL-07-030405
# RHEL-07-030500
# RHEL-07-030510
# RHEL-07-030520
# RHEL-07-030530
# RHEL-07-030540
# RHEL-07-030550
# RHEL-07-030441
# RHEL-07-030442
# RHEL-07-030580
# RHEL-07-030444
# RHEL-07-030590
# RHEL-07-030600
# RHEL-07-030610
# RHEL-07-030620
# RHEL-07-030630
# RHEL-07-030640
# RHEL-07-030650
# RHEL-07-030660
# RHEL-07-030670
# RHEL-07-030680
# RHEL-07-030690
# RHEL-07-030730
# RHEL-07-030700
# RHEL-07-030710
# RHEL-07-030720
# RHEL-07-030740
# RHEL-07-030750
# RHEL-07-030760
# RHEL-07-030770
# RHEL-07-030780
# RHEL-07-030560
# RHEL-07-030800
# RHEL-07-030810
# RHEL-07-030820
# RHEL-07-030830
# RHEL-07-030840
# RHEL-07-030850
# RHEL-07-030860
# RHEL-07-030871
# RHEL-07-030870
# RHEL-07-030872
# RHEL-07-030873
# RHEL-07-030874
# RHEL-07-030880
# RHEL-07-030890
# RHEL-07-030900
# RHEL-07-030910
# RHEL-07-030920
# RHEL-07-030819
# RHEL-07-030821
# RHEL-07-030360
# RHEL-07-030370
# RHEL-07-030380
# RHEL-07-030390
# RHEL-07-030400
# RHEL-07-030410
# RHEL-07-030420
# RHEL-07-030430
# RHEL-07-030440

CAT2 audit.rules:
  file.managed:
  - name:      /etc/audit/rules.d/disa_stig7.rules
  - source:    salt://disa_stig7/files/cat2/audit.rules.j2
  - template:  jinja
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030350
{% set audit_space_left = salt['grains.get']('stig_audit_space_left','75') %}
CAT2 RHEL-07-030350 auditd.conf space_left:
  file.replace:
  - name: /etc/audit/auditd.conf
  - pattern: |
      ^space_left\s=\s.+$
  - repl: "space_left = {{ audit_space_left }}\n"
  - not_found_content: "space_left = {{ audit_space_left }}"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030351
CAT2 RHEL-07-030351 auditd.conf space_left_action:
  file.replace:
  - name: /etc/audit/auditd.conf
  - pattern: |
      ^space_left_action\s=\s.+$
  - repl: "space_left_action = email\n"
  - not_found_content: "space_left_action = email"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030352 030340
CAT2 RHEL-07-030352 auditd.conf action_mail_acct:
  file.replace:
  - name: /etc/audit/auditd.conf
  - pattern: |
      ^action_mail_acct\s=\s.+$
  - repl: "action_mail_acct = root\n"
  - not_found_content: "action_mail_acct = root"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

auditd.conf flush:
  file.replace:
  - name: /etc/audit/auditd.conf
  - pattern: |
      ^flush\s*=\s.+$
  - repl: "flush = data\n"
  - not_found_content: "flush = data"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030360
CAT2 RHEL-07-030360 audit.rules execv:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid\n"
  - not_found_content: "-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -k setuid"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -k setuid\n"
  - not_found_content: "-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -k setuid"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030360
CAT2 RHEL-07-030360 audit.rules execv2:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\-a\s*always,exit\s*\-F\*arch=b64\*\-S\*execve\*.+$
  - repl: "-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k setgid\n"
  - not_found_content: "-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k setgid"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S execve -C gid!=egid -F egid=0 -k setgid"
  - not_found_content: "-a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -k setgid"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030370
CAT2 RHEL-07-030370 audit.rules chown:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - not_found_content: "-a always,exit -F arch=b32 -S chown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030390
CAT2 RHEL-07-030390 audit.rules lchown:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S lchown -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030400
CAT2 RHEL-07-030400 audit.rules fchownat:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S fchownat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030410
CAT2 RHEL-07-030410 audit.rules chmod:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S chmod -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030420
CAT2 RHEL-07-030420 audit.rules fchmod:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S fchmod -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030430
CAT2 RHEL-07-030430 audit.rules fchmodat:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030440
CAT2 RHEL-07-030440 audit.rules setxattr:
  file.replace:
  {% if grains['osarch'] == 'x86_64' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b64\*.+$
  - repl: "-a always,exit -F arch=b64 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b64 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% elif grains['osarch'] == 'x86_32' %}
  - name: /etc/audit/audit.rules
  - pattern: |
      ^\\-a\s*always,exit\s*arch=b32\*.+$
  - repl: "-a always,exit -F arch=b32 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod\n"
  - not_found_content: "-a always,exit -F arch=b32 -S setxattr -F auid>=1000 -F auid!=4294967295 -k perm_mod"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
  {% endif %}

# CAT2
# RHEL-07-030010
CAT2 RHEL-07-030010 audit.rules:
  cmd.run:
    - name: auditctl -f 2
  file.append:
  - name: /etc/audit/rules.d/audit.rules
  - text:
    - "-f 2"
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030330
{% if disa_stig7.log_server %}
audisp-remote file:
  file.managed:
  - name: /etc/audisp/audisp-remote.conf
  - user: root
  - group: root
  - mode: 0600
  - replace: false

CAT2 RHEL-07-030330 audisp audisp-remote remote_server:
  file.replace:
  - name: /etc/audisp/audisp-remote.conf
  - pattern: |
      ^remote_server\s=\s.+$
  - repl: "remote_server = {{ disa_stig7.log_server }}\n"
  - not_found_content: "remote_server = {{ disa_stig7.log_server }}"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030310
CAT2 RHEL-07-030310 audisp audisp-remote enable_krb5:
  file.replace:
  - name: /etc/audisp/audisp-remote.conf
  - pattern: |
      ^enable_krb5\s=\s.+$
  - repl: "enable_krb5 = yes\n"
  - not_found_content: "enable_krb5 = yes"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# CAT2
# RHEL-07-030320
CAT2 RHEL-07-030320 audisp audisp-remote disk_full_action:
  file.replace:
  - name: /etc/audisp/audisp-remote.conf
  - pattern: |
      ^disk_full_action\s=\s.+$
  - repl: "disk_full_action = syslog\n"
  - not_found_content: "disk_full_action = syslog"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart

# RHEL-07-030321
CAT2 RHEL-07-030321 audisp audisp-remote network_failure_action:
  file.replace:
  - name: /etc/audisp/audisp-remote.conf
  - pattern: |
      ^network_failure_action\s=\s.+$
  - repl: "network_failure_action = syslog\n"
  - not_found_content: "network_failure_action = syslog"
  - append_if_not_found: True
  - watch_in:
    - cmd: auditd service restart
{% endif %}

auditd service restart:
  cmd.wait:
  - name: service auditd restart
