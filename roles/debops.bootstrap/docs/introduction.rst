Introduction
============

``debops.bootstrap`` is an Ansible role that heps perpare a given Debian/Ubuntu
host to be managed by Ansible. It will install required Python packages,
configure hostname and domain, create an admin account and set up SSH public
keys for passwordless SSH access.

Installation
~~~~~~~~~~~~

This role requires at least Ansible ``v1.8.0``. To install it, run::

    ansible-galaxy install debops.bootstrap

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
