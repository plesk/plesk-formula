{% set fqdn = grains['fqdn'] %}
{% set ip = grains['ipv4'][0] if grains['ipv4'][1] == '127.0.0.1' else grains['ipv4'][1] %}
{% set email = salt['pillar.get']('plesk:admin:email', 'user@example.com') %}
{% set white_ips = salt['pillar.get']('plesk:fail2ban:white_ips', ['127.0.0.1']) %}
{% set jails = salt['pillar.get']('plesk:fail2ban:jails', ['ssh']) %}
{% set pass = salt['pillar.get']('plesk:admin:password', 'setup') %}

setup_plesk:
  cmd.run:
    - name: |
        PSA_PASSWORD={{ pass }} /usr/sbin/plesk bin init_conf --init -shared_ips add:{{ ip }} -license_agreed true -admin_info_not_required true -send_announce false -send_tech_announce false -hostname {{ fqdn }} -passwd "" -company plesk.com -name Administrator -email {{ email }}
        /usr/sbin/plesk bin server_pref -u -waf-rule-engine on -waf-rule-set tortix -keep-local-backup false -crontab-secure-shell /bin/bash
        /usr/sbin/plesk bin locales --set-default ru-RU
        /usr/sbin/plesk bin panel_gui -p -domain_registration false
        /usr/sbin/plesk bin panel_gui -p -cert_purchasing false
        /usr/sbin/plesk sbin pci_compliance_resolver --enable
    - unless: /usr/sbin/plesk bin init_conf -c &>/dev/null

create_default_subscription:
  cmd.run:
    - name: /usr/sbin/plesk bin subscription -c {{ fqdn }} -hosting true -ip {{ ip }} -login support -passwd $(/usr/bin/openssl rand -base64 12)
    - unless: /usr/sbin/plesk bin subscription -i {{ fqdn }} &>/dev/null

fail2ban_plesk:
  cmd.run:
    - name: |
        /usr/sbin/plesk bin ip_ban --enable
        /usr/sbin/plesk bin ip_ban --enable-jails "{{ jails | join (';') }}"
        /usr/sbin/plesk bin ip_ban --add-trusted "{{ ip }};{{ white_ips | join (';') }}"
    - onlyif: /usr/sbin/plesk bin ip_ban -i | grep inactive -q