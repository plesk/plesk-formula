{% set fqdn = grains['fqdn'] %}
{% set email = salt['pillar.get']('plesk:admin:email', 'user@example.com') %}
{% set extension_url = 'https://ext.plesk.com/packages/f6847e61-33a7-4104-8dc9-d26a0183a8dd-letsencrypt/download' %}

install_letsencrypt_plesk:
  cmd.run:
    - name: /usr/sbin/plesk bin extension --install-url {{ extension_url }}
    - unless: /usr/sbin/plesk bin extension --list | grep -q letsencrypt

retrieve_certificate_for_default_domain:
  cmd.run:
    - name: /usr/sbin/plesk bin extension --exec letsencrypt cli.php -d {{ fqdn }} --letsencrypt-plesk:plesk-secure-panel --email {{ email }}
    - unless: /usr/sbin/plesk bin certificate -l -domain {{ fqdn }} | grep -q "Lets Encrypt"