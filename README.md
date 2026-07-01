Redmine Extended Workflows plugin
======================

This plugin aims to enhance standard workflows by introducing new configuration options.

Installation
------------

This plugin is compatible with Redmine 4.2.0+.

Please apply general instructions for plugins [here](http://www.redmine.org/wiki/redmine/Plugins).

First download the source or clone the plugin and put it in the "plugins/" directory of your redmine instance.

Then execute:

    $ bundle install
    $ rails redmine:plugins

And finally restart your Redmine instance.

Test status
-----------

| Plugin branch | Redmine Version | Test Status       |
|---------------|-----------------|-------------------|
| master        | 6.1.3           | [![6.1.3][1]][5]  |
| master        | 7.0.0           | [![7.0.0][2]][5]  |
| master        | master          | [![master][4]][5] |

[1]: https://github.com/nanego/redmine_extended_workflows/actions/workflows/6_1_3.yml/badge.svg
[2]: https://github.com/nanego/redmine_extended_workflows/actions/workflows/7_0_0.yml/badge.svg
[3]: https://github.com/nanego/redmine_extended_workflows/actions/workflows/master.yml/badge.svg
[5]: https://github.com/nanego/redmine_extended_workflows/actions

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
