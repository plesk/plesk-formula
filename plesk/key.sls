{% set license = salt['pillar.get']('plesk:license') %}
{% if license %}
install_plesk_license:
  cmd.run:
    - name: /usr/sbin/plesk bin license -i {{ license }}
    - if: test -e /etc/sw/keys/keys/plesk-default-key.xml
{% endif %}