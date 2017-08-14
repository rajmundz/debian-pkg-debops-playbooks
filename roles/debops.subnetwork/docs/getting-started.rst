Getting started
===============

.. contents::
   :local:


Example inventory
-----------------

To run ``debops.subnetwork`` on host given in
``debops_service_subnetwork`` Ansible inventory group:

.. code:: ini

    [debops_service_subnetwork]
    hostname

By default there are no IPv4/IPv6 subnets configured by the role, so you need
to specify them by yourself in the Ansible inventory. To do that, you need to
configure an entry in the form of ``address/prefix``, where address is the IP
address of the subnetwork interface and prefix is the CIDR subnet size:

.. code:: yaml

   subnetwork__addresses: [ '192.0.2.1/24', '2001:db8:deb0::1/48' ]

Example playbook
----------------

Here's an example playbook that can be used to configure local networks::

    ---

    - name: Configure internal networks
      hosts: [ 'debops_service_subnetwork', 'debops_subnetwork' ]
      become: True

      roles:

        - role: debops.ifupdown
          tags: [ 'role::ifupdown' ]
          ifupdown_dependent_interfaces: '{{ subnetwork__ifupdown__dependent_list }}'
          when: subnetwork__addresses

        - role: debops.ferm
          tags: [ 'role::ferm' ]
          ferm_forward: '{{ subnetwork__kernel_forwarding|d() | bool }}'
          ferm_dependent_rules:
            - '{{ subnetwork__ferm__dependent_rules if subnetwork__addresses else [] }}'

        - role: debops.subnetwork
          tags: [ 'role::subnetwork' ]

