Introduction
============

`DokuWiki`_ is an easy to use, file-based wiki written in PHP5.
``debops.dokuwiki`` role installs this wiki on a specified host with ``nginx``
as a webserver (using `debops.nginx`_ Ansible role). You can optionally
configure multiple DokuWiki instances with shared base installation using
`DokuWiki vhost farm`_ mode.

.. _DokuWiki: http://dokuwiki.org/
.. _debops.nginx: https://github.com/debops/ansible-nginx/
.. _DokuWiki vhost farm: https://www.dokuwiki.org/farms

..
 Local Variables:
 mode: rst
 ispell-local-dictionary: "american"
 End:
