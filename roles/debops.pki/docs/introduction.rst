Introduction
============

The ``debops.pki`` role provides a standardized management of the X.509
certificates on hosts controlled by Ansible. Other Ansible roles can utilize
the environment created by ``debops.pki`` to automatically enable TLS/SSL
encrypted connections.

Using this role, you can bootstrap a Public Key Infrastructure in your
environment using an internal Certificate Authority, easily switch the active
set of certificates between internal and external Certificate Authorities, or
use the ACME protocol to automatically obtain signed certificates from CA that
support it (currently, `Let's Encrypt <https://letsencrypt.org/>`_).

Installation
~~~~~~~~~~~~

This role requires at least Ansible ``v2.0.0``. To install it, run::

    ansible-galaxy install debops.pki

Ansible Controller requirements
-------------------------------

Some operations performed by the ``debops.pki`` role are done on Ansible
Controller. However, DebOps roles are not designed to manage Ansible Controller
host directly, so they cannot automatically install the required software.

Software packages required by the role on Ansible Controller::

    bash >= 4.3.0
    openssl >= 1.0.1

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
