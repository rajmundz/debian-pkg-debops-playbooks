Getting started
===============

.. contents::
   :local:

Initial configuration
---------------------

The default configuration of the ``debops.pki`` role and environment it creates
is designed to automatically provide valid X.509 certificates within the DebOps
cluster - a central Certificate Authority located on Ansible Controller
automatically signs certificate requests from remote hosts, which are uploaded
by Ansible to the ``secret/`` directory. Signed certificates are downloaded to
the remote hosts and automatically enabled, when necessary.

All of the remote hosts managed by DebOps will have the internal Root
Certificate Authority certificate installed in the system CA store. This will
ensure that the hosts within the cluster will automatically trust each other
and encrypted communication within the cluster should be possible without
further intervention.

Because of the nature of how X.509 certificates are created and maintained
(they cannot be "updated", per se, only new ones can be issued by the CA), it's
a good practice to create a test deployment of the PKI, and check if the
generated certificates are acceptable (correct Distinguished Name, certificate
validity times, etc.). There are some important role variables which might need
to be set in the inventory for best results.

Maintaining a secure Certificate Authority is a complicated process, and to
ensure secure operation additional steps might be needed. You should read the
rest of the ``debops.pki`` documentation to find out which parts of the created
environment are sensitive and require additional steps to ensure secure
operation.

Useful global parameters
------------------------

The environment managed by the ``debops.pki`` role is distributed between
Ansible Controller and remote hosts. Due to how task delegation in Ansible is
designed, some of the variables that are important for Ansible Controller
operation, are "sourced" on remote hosts. Therefore it's a good practice to
define them in the Ansible inventory ``all`` group (usually
``ansible/inventory/group_vars/all/pki.yml`` for consistency between different
remote hosts.

Most of these variables are related to Certificate Authority operation, the
ones you are likely to change are:

``pki_ca_domain``
  This is the DNS domain used as a base for the internal Certificate Authority
  Distinguished Names. If you use more than one domain in your environment, you
  should set this variable as your preferred domain on all hosts, through
  Ansible inventory.

  If you use VPS hosts provided by an external organization, they might be
  configured with no default domain, or the provider domain might be set up by
  default. Make sure that you check what domain is used by your remote hosts.

``pki_ca_organization``
  This is the Organizations name used as a base for the internal
  Certificate Authority Distinguished Names.

``pki_ca_root_dn``, ``pki_ca_domain_dn``, ``pki_ca_service_dn``
  These variables define the Distinguished Name, or Subject, of the Root
  Certificate Authority and Domain Certificate Authority. The value is a list
  of DN entries which define the subject.

Example inventory
-----------------

In DebOps, the ``debops.pki`` role is included in the ``common.yml`` playbook
and is run automatically on all of the managed hosts. You don't need to
specifically enable it in Ansible's inventory.

Example playbook
----------------

The ``debops.pki`` role requires a specialized Ansible playbook for correct
operation. Additional directories required by the role are created in the
``secret/`` directory on Ansible Controller, and this requires use of the
special ``debops.pki/env`` role provided within the main role.

.. code-block:: yaml

   ---
   - name: Manage Public Key Infrastructure
     hosts: [ 'debops_all_hosts', 'debops_service_pki' ]
     become: True

     roles:

       - role: debops.pki/env
         tags: [ 'role::pki', 'role::secret' ]

       - role: debops.secret
         secret_directories:
           - '{{ pki_env_secret_directories }}'
         tags: [ 'role::secret' ]

       - role: debops.pki
         tags: [ 'role::pki' ]

