Changelog
=========

v0.2.1
------

*Released: 2016-02-01*

- Change how role detects PostgreSQL version. The new method will use
  ``apt-cache policy`` to use the version determined by APT preferences instead
  of choosing first version from available packages. This fixes an issue when
  multiple PostgreSQL versions are available but the preferred one is not the
  first one. [drybjed]

- Add configuration variables for ``debops.apt_preferences`` role. The
  configuration will make sure that PostgreSQL 9.4 from ``jessie-backports``
  repository is installed on Debian Wheezy hosts. [drybjed]

v0.2.0
------

*Released: 2015-10-13*

- Remove parts of the role that are related to PostgreSQL server management. [drybjed]

- Add support for upstream PostgreSQL repository. [drybjed]

- Clean up package installation code. [drybjed]

- Add client-side management of PostgreSQL roles and databases. [drybjed]

- Add an option to set role password expiration. [drybjed]

- Update documentation. [drybjed]

v0.1.0
------

*Released: 2015-09-25*

- Add Changelog. [drybjed]

