Default variables: configuration
================================

Some of ``debops.postgresql`` default variables have more extensive
configuration than simple strings or lists, here you can find documentation and
examples for them.

.. contents::
   :local:
   :depth: 1

.. _postgresql_user_clusters:

postgresql_user_clusters
------------------------

This list defines what entries will be set in
``/etc/postgresql-common/user_clusters`` configuration file. It is used by
``pg_wrapper`` in Debian to direct PostgreSQL-related commands to correct
clusters. DebOps uses the default entry to redirect PostgrSQL-related commands
like ``psql`` to either local or remote PostgreSQL server.

Each entry is defined by a YAML dict. Supported parameters:

``user``
  Required. String or list with UNIX account usernames to include in a given
  entry. You can specify ``*`` to use any user account.

``group``
  Required. String or list with UNIX group names to include in a given entry.
  You can specify ``*`` to use any group.

``version``
  Optional. Specify PostgreSQL version to use for a given entry. If not
  defined, default PostgreSQL detected by the role will be used.

``cluster``
  Optional. Specify name of the cluster to direct the commands to. If not
  specified, ``main`` cluster will be used.

``host``
  Optional. IP address or hostname of the server the PostgreSQL database is
  stored as. Requires ``port`` to be specified as well. Replaces ``cluster``.

``port``
  Optional. TCP port to connect to as the PostgreSQL server. Requires ``host``
  to be specified as well. Replaces ``cluster``.

``database``
  Required. Name of the database to connect to by default. If ``*`` is
  specified, users will connect to the database with the same name as their
  UNIX account.

.. _postgresql_roles:

postgresql_roles
----------------

PostgreSQL uses "roles" as database accounts as well as groups. Roles can have
certain permissions granted to them by the server which allow access to
database objects. This list can be used to create roles on a PostgreSQL server,
each role is defined as a YAML dictionary.

``role`` or ``name``
  Required. Name of a given role.

``port``
  Optional. By default roles are created on the local or remote PostgreSQL
  server's default cluster (``5432``). You can specify a different port to
  change the cluster which will be used.

``password``
  Optional. Specify password for a given PostgreSQL role. If not set, a random
  password will be generated and stored in ``secret/`` directory. See
  ``debops.secret`` role for more details.

``encrypted``
  Optional, bool. Specify if a given password is already encrypted or not.

``expires``
  Optional. Specify password expiration date as a PostgreSQL timestamp value.

``flags``
  Optional. YAML list of role attribute flags which should be applied to
  a given PostgreSQL role. Choices: ``[NO]SUPERUSER``, ``[NO]CREATEROLE``,
  ``[NO]CREATEUSER``, ``[NO]CREATEDB``, ``[NO]INHERIT``, ``[NO]LOGIN``,
  ``[NO]REPLICATION``.

If a given role should manage a particular database, you can specify additional
parameters:

``db``
  Name of the database to manage. Only one database can be configured in a role
  entry at a time.

``priv``
  YAML list of privileges to grant for a given role to specified database. List
  will be joined using ``/`` character into one privilege string.

Examples
~~~~~~~~

Create a PostgreSQL role::

    postgresql_roles:
      - name: 'alpha'

Create a role and grant specific attribute flags::

    postgresql_roles:
      - name: 'beta'
        flags: [ 'NOLOGIN' ]

Create a role and grant privileges to a particular database::

    postgresql_roles:
      - name: 'gamma'
        db: 'gamma'
        priv: [ 'CONNECT', 'table1:ALL' ]

.. _postgresql_groups:

postgresql_groups
-----------------

Access to one or more PostgreSQL roles can be granted to other roles; that way
an application role and database role can have different set of privileges.
This list can be used to define these "groups" automatically. Recognized
parameters:

``roles``
  Required. List of roles which will be granted access to specified "groups".

``groups``
  Required. List of role "groups" to grant access to.

``database``
  Required. Name of the database on which to grant privileges.

``port``
  Optional. By default roles are managed on the local or remote PostgreSQL
  server's default cluster (``5432``). You can specify a different port to
  change the cluster which will be used.

Examples
~~~~~~~~

Grant membership to other roles::

    postgresql_groups:
      - roles:  [ 'alpha', 'beta' ]
        groups: [ 'gamma' ]
        database: 'gamma'

.. _postgresql_databases:

postgresql_databases
--------------------

List of PostgreSQL databases to create or manage on a PostgreSQL server. Known
parameters:

``database`` or ``name``
  Required. Database name.

``owner``
  Optional. Specifies the PostgreSQL role which will be an owner of
  a particular database. If not specified, database will be owned by PostgreSQL
  superuser role, usually ``postgres``.

  If owner is specified, given role will be granted all privileges to the
  database and will have grant option enabled for a given database.

``template``
  Optional. Specify name of the database which will be used as the template for
  new database.

``encoding``
  Optional. Default encoding used by a given database.

Examples
~~~~~~~~

Create database owned by a specified role::

    postgresql_databases:
      - name: 'gamma'
        owner: 'gamma'

.. _postgresql_pgpass:

postgresql_pgpass
-----------------

The ``~/.pgpass`` configuration file is used to store usernames and passwords
used to login to local or remote PostgreSQL databases. Using this list you can
configure entries for different servers on UNIX accounts. If an account or
group is not present, it will be created automatically.

Each entry is defined by a YAML dictionary. Recognized parameters:

``owner``
  Required. Specify name of the UNIX account that should be configured to
  access PostgreSQL databases. If that account doesn't exist, it will be
  created automatically as a local account.

``group``
  Optional. Specify default group to use for a UNIX account. If it doesn't
  exist, it will be created as a local group. If it's not specified, a group
  with the same name as ``owner`` will be created automatically.

``system``
  Optional. If ``True`` (default), created local accounts will be "system"
  accounts with UID < 1000. If ``False``, created accounts and groups will be
  "normal" accounts and groups.

``home``
  Specify home directory of created UNIX account. If not specified, parameter
  will be omitted (not changed if account is already present).

``server``
  Optional. Specify IP address or FQDN hostname of the server that you want to
  configure. If not specified, default server will be guessed automatically
  from ``postgresql_server`` variable.

``port``
  Optional. Specofy default TCP port to use for PostgreSQL server entry. If not
  specified, ``postgresql_port`` value will be used instead.

``database``
  Optional. Specify name of the database that should be covered by a given
  entry. If not specified, ``*`` will be used which means any database.

``role``
  Optional. Specify PostgreSQL role covered by a given entry. If not specified,
  ``owner`` will be used by default.

``password``
  Optional. Specify cleartext password which should be used with a given entry.
  If not specified, password will be pulled from ``secret/`` directory managed
  by ``debops.secret`` Ansible role.

Examples
~~~~~~~~

Create ``~/.pgpass`` entry for a role with any database::

    postgresql_pgpass:
      - owner: 'alpha'

Create ``~/.pgpass`` entry for a specific database::

    postgresql_pgpass:
      - owner: 'gamma'
        database: 'gamma'

