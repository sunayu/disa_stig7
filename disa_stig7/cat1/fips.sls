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

include:
  - disa_stig7.grub

# CAT1
# RHEL-07-021350
fips pkgs:
  pkg.installed:
  - pkgs:
    - dracut-fips
    - dracut-fips-aesni
    - prelink
  - watch_in:
    - cmd: grub-mkconfig

fips disable prelink config:
  file.managed:
  - name: /etc/sysconfig/prelink
  - contents: 'PRELINKING=no'
  - mode: 0644
  - watch_in:
    - cmd: fips disable prelink
    - cmd: grub-mkconfig

fips disable prelink:
  cmd.wait:
  - name: /usr/sbin/prelink -ua
  - watch_in:
    - cmd: grub-mkconfig
  - require:
    - pkg: fips pkgs

fips dracut setup:
  cmd.run:
  - name: "dracut -f"
  - unless: "cat /etc/default/grub |grep fips=1"
  - watch_in:
    - cmd: grub-mkconfig
  - require:
    - cmd: fips disable prelink

fips default grub:
  file.replace:
  - name: /etc/default/grub
  - pattern: |
      ^(GRUB_CMDLINE_LINUX=((?!fips=1).)*)"$
  - repl: |
      \1 fips=1"
  - watch_in:
    - cmd: grub-mkconfig
  - require:
    - cmd: fips dracut setup

# This kills usb keyboards when entering luks pw
fips no usb grub:
  file.replace:
  - name: /etc/default/grub
  - pattern: |
      ^(GRUB_CMDLINE_LINUX=((?!nousb).)*)"$
  - repl: |
      \1 nousb"
  - watch_in:
    - cmd: grub-mkconfig

{% if grains['stig_boot_device'] != grains['stig_root_device'] %}
fips default grub add boot:
  file.replace:
  - name: /etc/default/grub
  - pattern: |
      ^(GRUB_CMDLINE_LINUX=((?!boot={{ grains['stig_boot_device'] }}).)*)"$
  - repl: |
      \1 boot={{ grains['stig_boot_device'] }}"
  - watch_in:
    - cmd: grub-mkconfig
{% endif %}
