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

{% from "disa_stig7/sshd.sls" import set_sshd_conf %}

include:
  - disa_stig7.sshd

# CAT2
# RHEL-07-010441
{{ set_sshd_conf('CAT2','RHEL-07-010441','PermitUserEnvironment','no') }}

# CAT2
# RHEL-07-010442
{{ set_sshd_conf('CAT2','RHEL-07-010442','HostbasedAuthentication','no') }}

# CAT2
# RHEL-07-040110
{{ set_sshd_conf('CAT2','RHEL-07-040110','Ciphers','aes128-ctr,aes192-ctr,aes256-ctr') }}

# CAT2
# RHEL-07-040170
{{ set_sshd_conf('CAT2','RHEL-07-040170','Banner','/etc/issue') }}

# CAT2
# RHEL-07-040320
{{ set_sshd_conf('CAT2','RHEL-07-040320','ClientAliveInterval','600') }}

# CAT2
# RHEL-07-040340
{{ set_sshd_conf('CAT2','RHEL-07-040340','ClientAliveCountMax','0') }}

# CAT2
# RHEL-07-040370
{{ set_sshd_conf('CAT2','RHEL-07-040370','PermitRootLogin','no') }}

# CAT2
# RHEL-07-040350
{{ set_sshd_conf('CAT2','RHEL-07-040350','IgnoreRhosts','yes') }}

# CAT2
# RHEL-07-040380
{{ set_sshd_conf('CAT2','RHEL-07-040380','IgnoreUserKnownHosts','yes') }}

# CAT2
# RHEL-07-040330
{{ set_sshd_conf('CAT2','RHEL-07-040330','RhostsRSAAuthentication','yes') }}

# CAT2
# RHEL-07-040400
{{ set_sshd_conf('CAT2','RHEL-07-040400','MACs','hmac-sha2-512,hmac-sha2-256') }}

# CAT2
# RHEL-07-040430
{{ set_sshd_conf('CAT2','RHEL-07-040430','GSSAPIAuthentication','no') }}

# CAT2
# RHEL-07-040440
{{ set_sshd_conf('CAT2','RHEL-07-040440','KerberosAuthentication','no') }}

# CAT2
# RHEL-07-040450
{{ set_sshd_conf('CAT2','RHEL-07-040450','StrictModes','yes') }}

# CAT2
# RHEL-07-040460
{{ set_sshd_conf('CAT2','RHEL-07-040460','UsePrivilegeSeparation','sandbox') }}

# CAT2
# RHEL-07-040470
{{ set_sshd_conf('CAT2','RHEL-07-040470','Compression','no') }}

# Permissions on ssh private keys
sshd ssh_host_ecdsa_key mode:
  file.managed:
  - name: /etc/ssh/ssh_host_ecdsa_key
  - mode: 0600
  - replace: false

sshd ssh_host_ed25519_key mode:
  file.managed:
  - name: /etc/ssh/ssh_host_ed25519_key
  - mode: 0600
  - replace: false

sshd ssh_host_rsa_key mode:
  file.managed:
  - name: /etc/ssh/ssh_host_rsa_key
  - mode: 0600
  - replace: false

