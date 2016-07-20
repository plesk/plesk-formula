{%- set components = salt['pillar.get']('plesk:components') %}

install_plesk:
  cmd.run:
    - name: |
        /usr/bin/wget autoinstall.plesk.com/plesk-installer -O /root/plesk-installer
        chmod 0700 /root/plesk-installer
        /root/plesk-installer --select-product-id plesk --select-release-latest --install-component {{ components | join(' --install-component ') }}
    - unless: plesk version &>/dev/null
