Introduction
============

``debops.subnetwork`` is an Ansible role that creates and manages a local
network behind a bridge interface. It could also manage internal router
interfaces to a LAN. You can specify an IPv4 subnet and one or more
IPv6 subnets to configure it, the role will automatically configure basic
forwarding in any firewall and NAT for the IPv4 network.


Installation
~~~~~~~~~~~~

This role requires at least Ansible ``v2.0.0``. To install it, run::

    ansible-galaxy install debops.subnetwork

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
