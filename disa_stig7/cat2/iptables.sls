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

# Disable firewalld if its running
{% if salt['service.status']('firewalld') %}
iptables disable firewalld:
  service.dead:
  - name: firewalld
  - enable: false

iptables delete all chains:
  cmd.run:
  - name: iptables -X
{% endif %}

# CAT2
# RHEL-07-040290
iptables service install:
  pkg.installed:
  - name: iptables-services

# CAT2
# RHEL-07-040100
# RHEL-07-040250
# RHEL-07-040810
# RHEL-07-040820
iptables service:
  service.running:
  - name: iptables
  - enable: true

# ipv4
# Macro for easy adding of ports
{% macro add_input_rule (app, proto, port, position='1') -%}
iptables INPUT {{ app }} {{ proto }} {{ port }} accept:
  iptables.insert:
  - position: {{ position }}
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - connstate: NEW
  - dport: {{ port }}
  - proto: {{ proto }}
  - save: True
  - comment: '{{ app }} {{ proto }} {{ port }}'
{%- endmacro %}

# If we are not initialized flush chains
{% if not salt['grains.get']('stig_iptables_initialized', False) %}

# Make sure we don't lock ourselves out
iptables INPUT policy accept:
  iptables.set_policy:
  - chain: INPUT
  - policy: ACCEPT

iptables INPUT flush:
  iptables.flush:
  - name: INPUT

iptables OUTPUT flush:
  iptables.flush:
  - name: OUTPUT

iptables FORWARD flush:
  iptables.flush:
  - name: FORWARD

iptables init grain:
  grains.present:
  - name: stig_iptables_initialized
  - value: True
{% endif %}

iptables INPUT icmp accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - proto: icmp
  - save: True

iptables INPUT lo accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - in-interface: lo
  - save: true

iptables INPUT related established accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - connstate: RELATED,ESTABLISHED
  - save: True

iptables INPUT log:
  iptables.append:
  - chain: INPUT
  - jump: LOG
  - match: limit
  - limit: '1/min'
  - log-prefix: 'IPTables-Dropped: '
  - log-level: 4
  - save: true

iptables INPUT policy drop:
  iptables.set_policy:
  - chain: INPUT
  - policy: DROP
  - save: True

iptables FORWARD policy drop:
  iptables.set_policy:
  - chain: FORWARD
  - policy: DROP
  - save: True

# Add ports listed in disa_stig7.allowed_ports
{% for app, rules in disa_stig7.allowed_ports.items() %}
{%   for rule in rules %}
{%     for proto, port in rule.items() %}
{{       add_input_rule(app, proto, port) }}
{%     endfor %}
{%   endfor %}
{% endfor %}

ip6tables service:
  service.running:
  - name: ip6tables
  - enable: true

# Macro for easy adding of ports
{% macro add_6input_rule (app, proto, port, position='1') -%}
iptables ipv6 INPUT {{ app }} {{ proto }} {{ port }} accept:
  iptables.insert:
  - position: {{ position }}
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - connstate: NEW
  - dport: {{ port }}
  - proto: {{ proto }}
  - save: True
  - family: ipv6
  - comment: '{{ app }} {{ proto }} {{ port }}'
{%- endmacro %}

# If we are not initialized flush chains
{% if not salt['grains.get']('stig_ip6tables_initialized', False) %}
# Make sure we don't lock ourselves out
iptables ipv6 INPUT policy accept:
  iptables.set_policy:
  - chain: INPUT
  - policy: ACCEPT
  - family: ipv6

iptables ipv6 INPUT flush:
  iptables.flush:
  - name: INPUT
  - family: ipv6

iptables ipv6 OUTPUT flush:
  iptables.flush:
  - name: OUTPUT
  - family: ipv6

iptables ipv6 FORWARD flush:
  iptables.flush:
  - name: FORWARD
  - family: ipv6

iptables ipv6 init grain:
  grains.present:
  - name: stig_ip6tables_initialized
  - value: True
{% endif %}

iptables ipv6 INPUT icmp accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - proto: icmp
  - save: True
  - family: ipv6

iptables ipv6 INPUT lo accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - in-interface: lo
  - family: ipv6
  - save: true

iptables ipv6 INPUT related established accept:
  iptables.append:
  - chain: INPUT
  - jump: ACCEPT
  - match: state
  - connstate: RELATED,ESTABLISHED
  - save: True
  - family: ipv6

iptables ipv6 INPUT log:
  iptables.append:
  - chain: INPUT
  - jump: LOG
  - match: limit
  - limit: '1/min'
  - log-prefix: 'IPTables-Dropped: '
  - log-level: 4
  - family: ipv6
  - save: true

# Add ports listed in disa_stig7.allowed_ports
{% for app, rules in disa_stig7.allowed_ports.items() %}
{%   for rule in rules %}
{%     for proto, port in rule.items() %}
{{       add_6input_rule(app, proto, port) }}
{%     endfor %}
{%   endfor %}
{% endfor %}

iptables ipv6 INPUT policy drop:
  iptables.set_policy:
  - chain: INPUT
  - policy: DROP
  - family: ipv6
  - save: true

iptables ipv6 FORWARD policy drop:
  iptables.set_policy:
  - chain: FORWARD
  - policy: DROP
  - family: ipv6
  - save: true
