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

# Clamav comes from the epel repo
epel pkg:
  pkg.installed:
  - sources:
    - epel-release: https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# CAT1
# RHEL-07-030810
clamav pkg:
  pkg.installed:
  - pkgs:
    - clamav
    - clamav-update
    - clamav-scanner-systemd

# Salt needs some python deps for selinux
python deps:
  pkg.installed:
  - name: policycoreutils-python

# Selinux
clamav setsebool antivirus_can_scan_system:
  selinux.boolean:
  - name: antivirus_can_scan_system
  - value: 1
  - persist: true

clamav setsebool antivirus_use_jit:
  selinux.boolean:
  - name: antivirus_use_jit
  - value: 1
  - persist: true

# Setup freshclam (clamav updates)
clamav freshclam conf uncomment example:
  file.comment:
  - name: /etc/freshclam.conf
  - regex: ^Example
  - char: '#'

clamav freshclam conf uncomment UpdateLogFile:
  file.uncomment:
  - name: /etc/freshclam.conf
  - regex: ^UpdateLogFile
  - char: '#'

clamav freshclam conf uncomment LogFileMaxSize:
  file.uncomment:
  - name: /etc/freshclam.conf
  - regex: ^LogFileMaxSize
  - char: '#'

clamav freshclam conf uncomment LogTime:
  file.uncomment:
  - name: /etc/freshclam.conf
  - regex: ^LogTime
  - char: '#'

clamav freshclam conf uncomment LogRotate:
  file.uncomment:
  - name: /etc/freshclam.conf
  - regex: ^LogRotate
  - char: '#'

clamav freshclam service file:
  file.managed:
  - name: /usr/lib/systemd/system/clam-freshclam.service
  - contents:
    - '# Run the freshclam as daemon'
    - '[Unit]'
    - 'Description = freshclam scanner'
    - 'After = network.target'
    - '[Service]'
    - 'Type = forking'
    - 'ExecStart = /usr/bin/freshclam -d -c 4'
    - 'Restart = on-failure'
    - 'PrivateTmp = true'
    - '[Install]'
    - 'WantedBy=multi-user.target'

clamav freshclam service:
  service.running:
  - name: clam-freshclam
  - enable: true

# Setup clamav
clamd config file:
  file.managed:
  - name: /etc/clamd.d/scan.conf
  - contents:
    - 'LogFile /var/log/clamd.scan'
    - 'LogFileMaxSize 2M'
    - 'LogSyslog yes'
    - 'LogRotate yes'
    - 'LogTime yes'
    - 'LocalSocket /var/run/clamd.scan/clamd.sock'
    - 'User clamscan'
    - 'AllowSupplementaryGroups yes'

clamd service file:
  file.copy:
  - name: /usr/lib/systemd/system/clamd.service
  - source: /usr/lib/systemd/system/clamd@.service

clamd service fix:
  file.replace:
  - name: /usr/lib/systemd/system/clamd.service
  - pattern: '%i'
  - repl: 'scan'

clamav scan log:
  file.managed:
  - name: /var/log/clamd.scan
  - user: clamscan
  - group: clamscan
  - replace: False

# CAT2
# RHEL-07-030820
clamd service:
  service.running:
  - name: clamd
  - enable: true
