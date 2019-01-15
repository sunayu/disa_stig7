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
# RHEL-07-021600
# RHEL-07-021610
aide install:
  pkg.installed:
  - name: aide

# CAT2
# RHEL-07-021620
aide config settings FIPSR:
  file.replace:
  - name: /etc/aide.conf 
  - pattern: |
      ^FIPSR\s*=.+$
  - repl: "FIPSR = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha512\n" 

aide config settings ALLXTRAHASHES:
  file.replace:
  - name: /etc/aide.conf
  - pattern: |
      ^ALLXTRAHASHES\s*=.+$
  - repl: "ALLXTRAHASHES = rmd160+sha512+tiger\n"

aide config settings DATAONLY:
  file.replace:
  - name: /etc/aide.conf
  - pattern: |
      ^DATAONLY\s*=.+$
  - repl: "DATAONLY =  p+n+u+g+s+acl+selinux+xattrs+sha512\n"

aide config settings NORMAL:
  file.replace:
  - name: /etc/aide.conf
  - pattern: |
      ^NORMAL\s*=.+$
  - repl: "NORMAL = FIPSR+sha512"

# CAT2
# RHEL-07-020130
# RHEL-07-020140
CAT2 RHEL-07-020130 cron aide check:
  file.managed:
  - name: /etc/cron.daily/aide
  - mode: 0700
  - contents:
     - '#!/bin/sh'
     - aide --check > /var/log/aide/aidecheck-`date +%Y-%m-%d`.txt| /bin/mail -s "$HOSTNAME - Daily aide integrity check run" root@localhost

{% if not salt['grains.get']('stig_aide_initialized', False) %}
aide create inital db:
  cmd.run:
  - name: aide --init
  - order: last

aide copy initial db:
  file.managed:
  - name: /var/lib/aide/aide.db.gz
  - source: /var/lib/aide/aide.db.new.gz
  - force: true
  - order: last

aide init grain:
  grains.present:
  - name: stig_aide_initialized
  - value: True
  - order: last
{% endif %}
