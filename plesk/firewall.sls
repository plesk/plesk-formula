firewalld:
  service.running:
    - enable: True
    - reload: True

/etc/firewalld/services/plesk.xml:
  module.wait:
    - name: file.restorecon
    - path: /etc/firewalld/services/plesk.xml
    - watch:
      - file: /etc/firewalld/services/plesk.xml
  file.managed:
    - source: salt://plesk/files/plesk.xml
    - mode: 640
    - user: root
    - group: root

register_plesk_in_firewall:
  cmd.run:
    - name: |
        /usr/bin/firewall-cmd --reload
        /usr/bin/firewall-cmd --zone=public --add-service=plesk --permanent
        /usr/bin/firewall-cmd --reload
    - unless: /usr/bin/firewall-cmd --query-service=plesk --zone=public -q
    - onlyif: test -e /etc/firewalld/services/plesk.xml

/etc/proftpd.d/passive-ports.conf:
  file.managed:
    - source: salt://plesk/files/passive-ports.conf
    - mode: 644
    - user: root
    - group: root
