Changelog
=========

v0.3.1
------

*Unreleased*

- Add DebOps pre/post task hooks. [drybjed]

- Remove ``auth_admin_accounts`` list and related tasks. This list was used to
  create admin accounts, which interfered when these accounts were supposed to
  be system accounts instead of normal "user" accounts.

  Use the ``debops.users`` role instead to create local administrator accounts
  and add them to the ``admins`` group to grant them admin access.
  Bootstrap playbooks / scripts should do that automatically for default admin
  account. [drybjed]

- Cease management of ``su`` PAM configuration. Only thing that was managed was
  passwordless access given to specific system group; ``sudo`` is sufficient
  for this functionality. Already existing systems are unchanged. [drybjed]

- Add variable to specify umask for new home directories created by
  ``pam_mkhomedir`` PAM module. Default umask is set to ``0027``. [drybjed]

- Set the default ``UMASK`` value for ``useradd`` command to ``0027``. All new
  home directories will have ``0750`` permissions, which might affect content
  accessibility for different applications. [drybjed]

- Add support for ``pam_cracklib`` to enforce harder UNIX passwords. [drybjed]

- Remember previous 5 passwords set on each account using ``pam_pwhistory``
  module to enforce use of different passwords. [drybjed]

- Role will check if ``libnss-mdns`` package is present and enable/disable
  mDNS/Avahi support in ``/etc/nsswitch.conf`` accordingly. [drybjed]

- Change location of machine password in ``secret/``.

  Change where LDAP machine bind password is stored in ``secret/`` directory to
  make it more general and not based on ``nslcd``. This should make sharing
  machine password between different services easier.

  If administrator does not move passwords to new location in ``secret/``
  directory, this will result in Ansible creating new random passwords for each
  host and updating them in LDAP. This may require update of the machine
  password for each service that uses it. [drybjed]

- Change default machine password length to 48 characters. [drybjed]

- Allow for per-domain access in LDAP host filter. [drybjed]

- Change quotes in ``lineinfile`` task to correctly pass Tab characters through
  the template engine. [drybjed]

v0.3.0
------

*Released: 2015-03-30*

- Move all ``auth_ldap_*`` variables to ``auth_ldap_conf_`` namespace. [drybjed]

- ``auth_ldap`` variable is removed. Instead, ``/etc/ldap/ldap.conf`` is
  configured either if ``/etc/ldap/`` directory exists, or ``ldap`` is
  enabled in ``auth_nsswitch`` [drybjed]

- By a popular demand, ``auth_ldap_conf`` variable is brought back and can be
  used to disable configuration of ``/etc/ldap/ldap.conf``. [drybjed]

- ``auth_ldap_tls`` variable has been converted from a text block into separate
  TLS variables. [drybjed]

- Configuration of ``/etc/nsswitch.conf`` is slightly modified, now
  ``auth_nsswitch`` variable controls presence and order of specific database
  entries in the configuration file. [drybjed]

- Add LDAP filtering in ``/etc/nslcd.conf``. By default ``nslcd`` will only
  search LDAP accounts with ``uid`` greater than 1000. With additional
  ``ldapns`` schema enabled in OpenLDAP server, only accounts with specific
  attributes will be allowed to login. [drybjed]

v0.2.1
------

*Released: 2015-02-25*

- ``debops.auth`` LDAP configuration tasks will now use new LDAP support in
  ``debops.secret``. [drybjed]

- Required Ansible version is changed to ``1.8.0+``. [drybjed]

- ``nslcd`` daemon will now be correctly restarted when its configuration file
  is changed. [drybjed]

- You can now specify the scrutiny level which ``nslcd`` will use while
  verifying the certificate sent by the LDAP server. [drybjed]

v0.2.0
------

*Released: 2015-02-24*

- Add NSS LDAP / PAM authentication support [drybjed]

v0.1.0
------

*Released: 2015-02-20*

- First release [drybjed]

