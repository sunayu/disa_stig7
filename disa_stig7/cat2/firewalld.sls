% from "disa_stig7/map.jinja" import disa_stig7 with context %}

# RHEL-07-040520
CAT2 RHEL-07-040520 firewalld pkg:
  pkg.installed:
  - name: firewalld

firewalld service:
  service.running:
  - name: firewalld
  - enable: true

# RHEL-07-040510
firewalld set default zone public:
  firewalld.present:
  - name: public
  - default: True
  - masquerade: False
  - rich_rules:
    - 'ipv4 filter IN_public_allow 0 -m tcp -p tcp -m limit --limit 25/minute --limit-burst 100 -j ACCEPT'
{% if 'allowed_services' in disa_stig7.firewalld %}
  - services:
{% for service in disa_stig7.firewalld.allowed_services %}
    - {{ service }}
{% endfor %}
{% endif %}
{% if 'allowed_ports' in disa_stig7.firewalld %}
  - ports:
{% for port in disa_stig7.firewalld.allowed_ports %}
    - {{ port }}
{% endfor %}
{% endif %}
  - watch_in:
    - service: firewalld service
