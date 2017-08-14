Changelog
=========

v0.1.1
------

*Unreleased*

- The ``tzdata`` package is frequently updated after the Debian Stable release
  and almost always newer version will be available from ``stable-updates``
  repository. This results in frequent e-mail messages informing about updated
  ``tzdata`` package available to install. This change ensures that on first
  configuration of a host, ``tzdata`` package will be updated automatically,
  which should help ensure that mentioned e-mails won't be sent. [drybjed]

- Configure ``/etc/timezone`` using template.

  In Ansible v2, using ``copy`` module with ``content`` parameter is
  unreliable, since the "end of line" character is rendered directly in the
  file. Switching to ``template`` module ensures that generated configuration
  file has correct formatting and should stop generating idempotency issues
  with ``tzdata`` package configuration. [drybjed]

- Check if NTP daemon can be installed in Ansible facts. [drybjed]

v0.1.0
------

*Released: 2015-11-13*

- Add Changelog [drybjed]

- Uninstall conflicting packages before installing the requested ones. This
  should fix `ntp and AppArmor issue`_ present in Ubuntu. [drybjed]

- Fixed ``ntp_listen: '*'`` for NTPd. [ypid]

- Added support for ``ntpdate``. [ypid]

.. _ntp and Apparmor issue: https://bugs.launchpad.net/ubuntu/+source/openntpd/+bug/458061

- Rewrite the installation tasks to work correctly on Ansible v2. [drybjed]

- Drop the dependency on ``debops.ferm`` Ansible role, firewall configuration
  is now defined in role default variables, and can be used by other roles
  through playbooks. [drybjed]

