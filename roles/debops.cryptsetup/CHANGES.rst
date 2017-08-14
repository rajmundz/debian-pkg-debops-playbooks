Changelog
=========

v0.3.1
------

*Released: 2016-04-04*

* Fixed usage of the ``role::cryptsetup:backup`` tag. [ypid]

* Fixed permission enforcement of the header backup on the Ansible controller. [jacksingleton]

* Remove header backups on remote system when ``cryptsetup_header_backup`` is set to ``False``. [ypid]

* No need to have a default for ``cryptsetup_state`` in the tasks.
  ``cryptsetup_state`` is expected to be a valid. [ypid]

v0.3.0
------

*Released: 2016-03-23*

- Renamed option ``cryptsetup_backup_header`` to ``cryptsetup_header_backup``
  and fixed the task to allow to disable header backups.
  Fixed: Honor the value of ``item.backup_header`` (``cryptsetup_devices``).
  Only disable header backups when you know what you are doing! [ypid]

- Renamed option ``cryptsetup_keyfile_location`` to
  ``cryptsetup_secret_path`` as it also contains the header backup on the
  Ansible controller. [ypid]

- Added support to setup and mount a encrypted filesystem without storing the
  keyfile on persistent storage of the remote system. [ypid]

- Removed default mount options ``user`` and ``auto`` because they are not good
  defaults for the role. [ypid]

- ``cryptsetup_mount_options`` and ``cryptsetup_crypttab_options`` are now
  lists of strings to allow more flexibility. [ypid]

- Added ``cryptsetup_secret_owner``, ``cryptsetup_secret_group`` and
  ``cryptsetup_secret_mode`` to allow to change file permissions of the secrets
  directory and files on the Ansible controller. [ypid]

- Renamed ``cryptsetup_use_random`` to ``cryptsetup_use_dev_random`` to
  emphasize it’s meaning. [ypid]

v0.2.1
------

*Released: 2015-12-01*

- Fail when keyfile has been generated but ciphertext block device is not
  available. [ypid]

- Update :file:`.travis.yml` configuration to test the role on Travis-CI.
  [drybjed]

- Update documentation and change the required Ansible version to ``v1.9.0``
  due to the ``become`` option replacing ``sudo``. [drybjed]

- Migrated to the DebOps project as ``debops.cryptsetup``. [drybjed]

v0.2.0
------

*Released: 2015-10-30*

- Major rewrite to allow to create the crypto and filesystem-layer by this
  role. [ypid]

- Wrote initial documentation. [ypid]

- Moved to `DebOps Contrib`_ (the role is still available under
  `ypid.crypttab`_ until it has been fully renamed to something like
  ``debops.cryptsetup``). [ypid]

v0.1.0
------

*Released: 2015-09-07*

- Initial release. [ypid]

.. _ypid.crypttab: https://galaxy.ansible.com/detail#/role/4559
.. _DebOps Contrib: https://github.com/debops-contrib/
