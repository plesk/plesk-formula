# What & Why
Install and configure [Plesk](https://www.plesk.com)

* Install Plesk and its components according list in pillar (see pillar.example)
* Initial configuration:
    * Disable send errors to centralized server
    * Set admin's email `admin@example.com` and password
    * Register IP as shared
    * Agree with license
    * Activate mod_security with `tortix` rule set
    * Specify default crontab shell
    * Set Russian locale as default
    * Disable domain registration and certificate purchasing promos
    * Set recommended SSL ciphers and protocols
    * Create default admin's subscription using hostname
    * Install Let's encrypt extension
    * Retrive and install SSL certificate for Plesk itself and default subscription

# List of states
The sequence is important!

1. `init` - install Plesk
2. `key` - install license key
3. `setup` - provide base settings and create default admin's subscription
4. `letsencrypt` - install Plesk extension and retrive SSL certificate for default subscription and Plesk itself. This state does not included to kitchenci because of obvious reason.
5. `firewall` - setup `firewalld` to open Plesk's related ports (CentOS 7 only)

# Tests

* Install [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com)
* Install [KitchenCI](http://kitchen.ci/) and its dependencies:
```
bundle install
```

* Run test installation
```
kitchen test
```