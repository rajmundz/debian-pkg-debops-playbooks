Default variables: configuration
================================

Some of ``debops.postgresql_server`` default variables have more extensive
configuration than simple strings or lists, here you can find documentation and
examples for them.

.. contents::
   :local:
   :depth: 1

.. _postgresql_server_hba:

postgresql_server_hba_*
-----------------------

`Host-Based Authentication <http://www.postgresql.org/docs/9.4/static/auth-pg-hba-conf.html>`_
configuration in ``debops.postgresql_server`` Ansible role is specified in
a set of lists:

- ``postgresql_server_hba_system``: controls the local and remote access to the
  database administrator role ``postgres``.

- ``postgresql_server_hba_replication``: control access to ``replication`` role
  and database.

- ``postgresql_server_hba_public``: controls access for public connections to
  ``postgres`` database, to allow certain applications like ``phpPgAdmin`` to
  work correctly.

- ``postgresql_server_hba_trusted``: control access by local UNIX accounts to
  certain roles/databases without the requirement to specify a password.

- ``postgresql_server_hba_local``: controls access to the databases by local
  UNIX accounts.

- ``postgresql_server_hba_remote``: controls access to the database by remote
  clients.

Each PostgreSQL cluster by default uses all of the above lists in its
``pg_hba.conf`` configuration file. A cluster can disable any list by
specifying its abbrevated name as a parameter with ``False``. For example::

    postgresql_server_cluster_main:
      name: 'main'
      port: '5432'
      hba_replication: False
      hba_public: False
      hba_trusted: False
      hba_local: False
      hba_remote: False

Above configuration will disable connections by trusted users (all users will
be required to specify a password) and from remote clients.

Additionally, each cluster can specify its own HBA entries using ``item.hba``
parameter which will be added at the end of the ``pg_hba.conf`` file. By
disabling selected global lists and adding custom entries you can redefine the
HBA configuration file as needed. Example::

    postgresql_server_cluster_main:
      name: 'main'
      port: '5432'
      hba_remote: False

      hba:
        - comment: 'Custom remote entries'
          type: 'hostssl'
          database: 'all'
          user: 'all'
          address: [ '192.0.2.0/24' ]
          method: 'md5'

Each entry in a HBA list is a YAML dictionary with parameters:

``comment``
  Optional. Comment added to a given entry in ``pg_hba.conf`` file.

``type``
  Required. Specifies connection type to use for a given entry. Known types are:

  - ``local``: local connections by UNIX accounts

  - ``host``: remote TCP connections, either with or without SSL

  - ``hostssl``: remote TCP connections, SSL is required

  - ``hostnossl``: remote TCP connections, plaintext is required

``database``
  Required. String or a list of database names that are controlled by a given
  HBA entry. You can use special names:

  - ``all``: all databases in a cluster

  - ``sameuser``: database with the same name as the PostgreSQL role

  - ``samerole``: all databases accessible by a given PostgreSQL role

  - ``@name``: file with a list of database names, relative to a given
    cluster's configuration directory in ``/etc``

``user``
  Required. String or a list of PostgreSQL roles that are controlled by a given
  HBA entry. You can use special names:

  - ``all``: all roles in on the PostgreSQL cluster

  - ``+role``: a specified role and all roles that are included in it

  - ``@name``: file with a list of roles, relative to a given cluster's
    configuration directory in ``/etc``

  - ``*postgres*``: a custom ``debops.postgresql_server`` name, it will be
    replaced by the UNIX system account name that manages a given cluster,
    usually ``postgres``

``address``
  Required by all types other than ``local``. A string or list of IP addresses
  or CIDR networks (``debops.postgresql_server`` does not support ip/netmask
  notation). You can use special names:

  - ``all``: any network clients

  - ``samenet``: any IP address from a subnet the host is directly connected to

``method``
  Required. Authentication method used by this HBA entry. You most likely
  either want ``peer`` for local connections or ``md5`` for remote connections.
  There are also other methods available, see the PostgreSQL documentation for
  information about how to use them.

``options``
  Optional. List of additional options specific to a given authentication
  method.

You can find different examples of how to defined HBA lists in
``defaults/main.yml`` file of ``debops.postgresql_server`` role.

.. _postgresql_server_ident:

postgresql_server_ident_*
-------------------------

`Ident maps
<http://www.postgresql.org/docs/9.4/static/auth-username-maps.html>`_ stored in
``pg_ident.conf`` configuration file is used to map local UNIX accounts to
PostgreSQL roles. This can be used to control what UNIX accounts can login to
the PostgreSQL server as a given role.

Ident maps should only be used by the local UNIX accounts with the ``peer``
authentication method. Using them for ``ident`` method with remote clients is
unreliable and discouraged - ``ident`` protocol is not meant to be used for
authentication or authorization.

By default, PostgreSQL clusters managed by the ``debops.postgresql_server``
role use global lists of ident maps:

- ``postgresql_server_ident_system``: a user mapping which specifies which
  system users can login as the ``postgres`` superuser role.

- ``postgresql_server_ident_trusted``: this user mapping can be used with the
  "trusted" HBA list to specify which local UNIX accounts can login without
  specifying a password. It's not set by default.

- ``postgresql_server_ident_local``: this user mapping can be used to define
  local UNIX accounts globally for all clusters. It's not set by default.

Above ident maps can be disabled in a given cluster by specifying their
abbvevated names in a parameter with ``False`` value. Example::

    postgresql_server_cluster_main:
      name: 'main'
      port: '5432'
      ident_trusted: False
      ident_local: False

You can specify custom lists of ident maps in a PostgreSQL cluster configuration::


    postgresql_server_cluster_main:
      name: 'main'
      port: '5432'
      ident_local: False

      ident:
        - map: 'main_local'
          user: [ 'user1', 'user2' ]
          role: 'role1'

Each ident map entry is a YAML dictionary with parameters:

``map``
  Required. Name of the user map, can be repeated in different entries.

``user``
  Required. String or list of UNIX user accounts to use in this map. You can
  use a regexp to specify accounts in various ways, see PostgreSQL
  documentation for more information.

  Special string ``*postgres*`` will be replaced by Ansible to the owner of the
  PostgreSQL cluster, usually ``postgres``.

``role``
  Optional. String or list of PostgreSQL roles to map to the UNIX accounts.

  If defined, specifies the PostgreSQL role to map to a given UNIX accounts.

  If not defined, each entry role name will be the same as the UNIX account
  name. Don't use this option with regexp user entries.

  Special string ``*postgres*`` will be replaced by Ansible to the owner of the
  PostgreSQL cluster, usually ``postgres``.

Examples can be found in the ``defaults/main.yml`` file of the
``debops.postgresql_server`` Ansible role.

.. _postgresql_server_clusters:

postgresql_server_clusters
--------------------------

On Debian and its derivatives, `PostgreSQL installation <https://wiki.debian.org/PostgreSql>`_
is based around "clusters", each cluster being run on a particular PostgreSQL
version and on a specific TCP port.  ``debops.postgresql_server`` is designed
to be used within that system, and allows you to create separate PostgreSQL
clusters. A default ``<version>/main`` cluster will be created, based on
default PostgreSQL version installed on a given host.

You can create and manage separate PostgreSQL clusters using
``postgresql_server_clusters`` list. Each cluster is defined as a YAML dict
with at least two parameters - ``name`` and ``port``. You should take care to
always use separate port for each cluster you define. Role will create an entry
for each cluster in ``/etc/services`` as well as maintain firewall
configuration as needed.

Some of the global variables defined in ``debops.postgresql_server`` concerning
clusters can be overriden on a cluster by cluster basis using their abbrevated
names (without ``postgresql_server_`` prefix) as cluster parameters. In
addition, almost all of the PostgreSQL parameters found in the
``postgresql.conf`` configuration file can be specified as cluster parameters
as well, to change the defaults.

List of some of the parameters that you can specify in a cluster configuration
entry:

``name``
  Required. Name of the cluster, used to separate different clusters based on
  the same PostgreSQL version.

``port``
  Required. TCP port to use for a given cluster. Default PostgreSQL port is
  ``5432``, more clusters usually use the next port number available.

``version``
  Optional. PostgreSQL version to use for a given cluster. If it's not
  specified, default detected version will be used, which is usually what you
  want.

``environment``
  Optional. Dictionary which specifies environment variables and their values
  that should be set for a given PostgreSQL cluster. Example::

      postgresql_server_cluster_main:
        name: 'main'
        port: '5432'

        environment:
          HOME: '/var/lib/postgresql'
          SHELL: '/bin/bash'

``listen_addresses``
  List of network interfaces specified by their addresses a given cluster
  should bind to. If not set, global value of
  ``postgresql_server_listen_addresses`` will be used instead.

``allow``
  List of IP addresses or CIDR subnets which should be allowed to connect to
  a given cluster.

