Getting started
===============

.. contents::
   :local:

General configuration
---------------------

On a new host, PostgreSQL server will be configured with a default cluster
``main`` running on port ``5432``. Cluster will only listen to connections from
``localhost``, Ansible management account and ``root`` account will be able to
login to the PostgreSQL server using ``postgres`` role, for example::

    $ psql -U postgres

The PostgreSQL version installed by the role will be a default version offered
by the distribution. If you want PostgreSQL 9.4 on Debian Wheezy, or an
upstream version of the server, you can enable the upstream APT repository by
adding in inventory::

    postgresql_server_upstream: True

After installation you can use ``debops.postgresql`` role to configure
PostgreSQL roles and databases.

Remote access to the database
-----------------------------

PostgreSQL server listens only for connections on ``localhost`` by default. To
enable remote access, you need to change the
``postgresql_server_listen_addresses`` list to specify either IP addresses of
the interfaces you want your host to listen on or ``*`` for all interfaces.
Because firewall by default blocks all connections to PostgreSQL server, you
will also need to specify IP addresses or CIDR subnets which should be able to
connect to the clusters. Example configuration of variables in inventory::

    postgresql_server_listen_addresses: [ '*' ]
    postgresql_server_allow: [ '192.0.2.0/24', '2001:db8::/32' ]

Default set of Host-Based Authentication rules permit connections from remote
hosts that are in the same subnet as the server, only over SSL, and requie the
correct password to be provided to accept connections. If you want to allow
connections from other subnets than the server, you will need to add your own
HBA entries to the PostgreSQL cluster configuration. Example for the default
cluster::

    postgresql_server_cluster_main:
      name: 'main'
      port: '5432'

      hba:
        - type: 'hostssl'
          database: 'samerole'
          user: 'all'
          address: [ '192.0.2.0/24', '2001:db8::/32' ]
          method: 'md5'

The ``debops.postgresql_server`` role is designed to use the PKI infrastructure
managed by ``debops.pki`` role. See its documentation for more details.

Example inventory
-----------------

To install and configure PostgreSQL server on a host, you need to add the host
to the ``[debops_postgresql_server]`` Ansible host group::

    [debops_postgresql_server]
    hostname

Example playbook
----------------

Here's an example playbook which uses the ``debops.postgresql_server`` role::

    ---
    - name: Configure PostgreSQL Server
      hosts: debops_postgresql_server

      roles:

        - role: debops.apt_preferences
          tags: [ 'role::apt_preferences' ]
          apt_preferences_dependent_list:
            - '{{ postgresql_server_apt_preferences_dependent_list }}'

        - role: debops.etc_services
          tags: [ 'role::etc_services' ]
          etc_services_dependent_list:
            - '{{ postgresql_server_etc_services_dependent_list }}'

        - role: debops.ferm
          tags: [ 'role::ferm' ]
          ferm_dependent_rules:
            - '{{ postgresql_server_ferm_dependent_rules }}'

        - role: debops.postgresql_server
          tags: [ 'role::postgresql_server' ]

Ansible tags
------------

You can use Ansible ``--tags`` or ``--skip-tags`` parameters to limit what
tasks are performed during Ansible run. This can be used after the host is first
configured to speed up playbook execution, when you are sure that most of the
configuration has not been changed.

Available role tags:

``role::postgresql_server``
  Main role tag, should be used in the playbook to execute all of the role
  tasks as well as role dependencies.

``role::postgresql_server:packages``
  Run tasks related to package installation

``role::postgresql_server:config``
  Run tasks related to PostgreSQL Server configuration.

``role::postgresql_server:auto_backup``
  Run tasks that configure AutoPostgreSQLBackup scripts.

