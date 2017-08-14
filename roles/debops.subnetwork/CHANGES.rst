Changelog
=========

v0.2.0
------

*Released: 2016-03-23*

- Remove most of the Ansible role dependencies, leaving only those that are
  required for the role to run correctly.

  Configuration of dependent services like firewall, TCP Wrappers, APT
  preferences is set in separate default variables. These variables can be used
  by Ansible playbooks to configure settings related to ``subnetwork`` in other
  services. [ypid]

- Renamed ``subnetwork_ifupdown_interfaces`` to
  ``subnetwork__ifupdown__dependent_list``. [ypid]

- Use ``subnetwork__ifupdown__dependent_list`` to generate Firewall entries
  instead of templating a file under :file:`/etc/ferm`. [ypid]

- Added the ``debops.subnetwork/env`` role to check Ansible inventory variables
  before starting to let dependency roles process them. [ypid]

- Changed namespace from ``subnetwork_`` to ``subnetwork__``.
  ``subnetwork_[^_]`` variables are hereby deprecated and you might need to
  update your inventory. This oneliner might come in handy to do this.

  .. code:: shell

     git ls-files -z | find -type f -print0 | xargs --null sed --in-place --regexp-extended 's/(subnetwork)_([^_])/\1__\2/g'

  [ypid]

- Documented basic usage of the role. [ypid]

- Enable packet forwarding through ``debops.ferm`` only when subnetwork
  addresses are defined. [drybjed]

- Change the default ``ifupdown`` configuration "weight" to put the subnetwork
  bridge after other bridges. [drybjed]

- Render the ``debops.ferm`` configuration only when ``subnetwork__addresses``
  has value, this fixes an issue when Ansible stops with an error when there
  are no addresses set. [drybjed]

- Remove the assert check in ``debops.subnetwork/env`` and replace it with
  conditional role execution in the playbook. [drybjed]

- Update documentation. [drybjed]

v0.1.1
------

*Released: 2015-06-02*

- Role is updated to use new features in ``debops.ifupdown``:

  Most of the "logic" behind how IP addresses were configured is now included
  in ``debops.ifupdown``. Instead of having separate variables for IPv4 and
  IPv6 addresses, you now should use ``subnetwork_addresses`` list to specify
  IPv4/IPv6 subnets to configure, in the "host/prefix" format.

  Names of generated files in ``/etc/network/interfaces.d/`` have been changed
  to no longer contain duplicate ``_ipv4_ipv4`` or ``_ipv6_ipv6`` suffixes,
  since ``debops.ifupdown`` automatically adds the network suffix. You need to
  remove old configuration files from ``/etc/network/interfaces.config.d/`` to
  prevent any problems with duplicate interface configuration.

  ``subnetwork_ipv{4,6}_options`` variables have been renamed to
  ``subnetwork_options{6}``. By default, bridge will be configured with
  "forward delay" 0 to help with DHCP requests.

  ``subnetwork_ifupdown_prepend_interfaces`` list has been removed.

  ``subnetwork_ipv4_gateway`` variable has been renamed to
  ``subnetwork_ipv4_nat_snat_interface`` to better reflect its purpose as it
  specifies the interface from which firewall should take an IPv4 address to
  use in SNAT directive. [drybjed]

- Added ``subnetwork_bridge_iface_regex`` variable to allow to use different
  ``subnetwork_iface`` names without modifying the default
  ``subnetwork_ifupdown_interfaces``. [ypid]

v0.1.0
------

*Released: 2015-05-12*

- Add Changelog. [drybjed]

- Disable automatically added ``allow-hotplug`` option in IPv6 bridge section.
  IPv6 is enabled automatically with IPv4 when bridge is brought up. [drybjed]

- Redefine ``subnetwork_ipv{4,6}_options`` variables.

  When you use multiple subnetwork interfaces, additional options provided in
  above variables for 1 interface would propagate into the rest of the
  interfaces. To change that, options variables are redefined as dicts with
  keys specifying the interface name and values being YAML text blocks with
  options.

  Note that dict keys must be specified explicitly, not as Jinja variables. See
  ``defaults/main.yml`` file for examples. [drybjed]

