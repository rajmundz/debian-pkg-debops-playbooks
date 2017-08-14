Introduction
============

This Ansible role lets you manage one or multiple swap files. You can also
manage kernel parameters related to how swap is used by the system.

Note that this role can not setup a swap file on a BTRFS filesystem.

Installation
~~~~~~~~~~~~

This role requires at least Ansible ``v1.9.0``. To install it, run::

    ansible-galaxy install debops.swapfile

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
