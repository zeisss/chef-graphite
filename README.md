# Description #

Installs and configures Graphite.  Much of the work in this cookbook reflects
work done by [Heavy Water Software](https://github.com/heavywater/chef-graphite)
and [Infochimps](https://github.com/infochimps-labs/ironfan-pantry/blob/master/cookbooks/graphite).

# Requirements #

## Platforms ##

* Ubuntu 11.10 (Oneiric)

## Cookbooks ##

* apache2
* python

# Attributes #

* `node["graphite"]["version"]` - Version of Graphite to install.
* `node["graphite"]["user"]` - User for Graphite and its components.
* `node["graphite"]["group"]` - Group for Graphite and its components.
* `node["graphite"]["carbon"]["line_receiver_interface"]` - IP for the line
  receiver to bind to.
* `node["graphite"]["carbon"]["pickle_receiver_interface"]` - IP for the pickle
  receiver to bind to.
* `node["graphite"]["carbon"]["cache_query_interface"]` - IP for the query
  cache to bind to.

# Recipes #

* `recipe[graphite]` will install Graphite and all of its components.
* `recipe[graphite::carbon]` will install Carbon.
* `recipe[graphite::dashboard]` will install Graphite's dashboard.
* `recipe[graphite::whisper]` will install Whisper.

# Usage #

Graphite's credentials default to username `root` and password `root` with an
e-mail address going no where.  Also, two schemas are provided by default:
`stats.*` for [StatsD](https://github.com/etsy/statsd) and a catchall that
matches anything.