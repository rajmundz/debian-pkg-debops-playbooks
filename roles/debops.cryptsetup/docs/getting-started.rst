.. include:: global.rst.inc


Getting started
===============

.. contents::
   :local:

Overview and terminology
------------------------

The following layers are involved in configuring an encrypted filesystem using
block device encryption:

#. Ciphertext block device: This can be any block device or partition on a block device.

#. Plaintext device mapper target: Created by `dm-crypt`_ under :file:`/dev/mapper/`.
   Opening this layer is called "mapping" or "decrypting" which means making
   the plaintext device mapper target available by loading and keeping the
   master key for the block cypher in volatile memory (RAM).

#. Plaintext mount point of the filesystem: Where the plaintext files can be accessed.
   Opening this layer is called "mounting".

Example inventory
-----------------

To configure encrypted filesystems on host given in
``debops_service_cryptsetup`` Ansible inventory group:

.. code:: ini

    [debops_service_cryptsetup]
    hostname

Example playbook
----------------

Here's an example playbook that can be used to manage cryptsetup::

    ---
    - name: Configure encrypted filesystems
      hosts: [ 'debops_service_cryptsetup' ]
      become: True

      roles:

        - role: debops.cryptsetup
          tags: [ 'role::cryptsetup' ]

Ansible tags
------------

You can use Ansible ``--tags`` or ``--skip-tags`` parameters to limit what
tasks are performed during Ansible run. This can be used after a host is first
configured to speed up playbook execution, when you are sure that most of the
configuration has not been changed.

Available role tags:

``role::cryptsetup``
  Main role tag, should be used in the playbook to execute all of the role
  tasks as well as role dependencies.

``role::cryptsetup:backup``
  LUKS header backup related tasks.
