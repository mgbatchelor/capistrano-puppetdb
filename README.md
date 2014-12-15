In an increasingly dynamic environment, you don't want to have to maintain multiple lists of servers for your capistrano deploys.
You also don't want to have to push changes to the server list through your whole CI/QA system.
Since you're already using puppet, why not just query PuppetDB for your server lists?

Enter this gem.

# Usage

In `Gemfile`:

```
gem 'capistrano-puppetdb'
```

In `Capfile`:

```
require 'capistrano/puppetdb'
```

in `config/deploy.rb`

```
set :puppetdb_server, "http://puppet.example.com:8080"
set :puppetdb_query_resource, "Site::Capistrano_role"
```

in `config/deploy/staging.rb`

```
set :puppetdb_query_tag, "cluster_staging"
```

This will query puppetdb at `http://puppet.example.com:8080` for resources of type `Site::Capistrano_role` and tag `cluster_staging` and return servers from that.

The `role` parameter on the resource returned will be used as the capistrano role for the server, and the `certname` value of the puppetdb object will be used for the fqdn of the machine.

I just have a dummy no-op resource in my puppet code that is only used for being queried by this gem and pepper it throughout my code with various capistrano roles that might need to be used.

# configuration variables

## `puppetdb_server`

Sets the endpoint for the puppetdb server to be queried.

## `puppetdb_query_resource_type`

Sets the resource type to query for.

## `puppetdb_query_tag`

Sets the tag to query for.

## `puppetdb_role_parameter`

Sets the parameter on the resource to grab the role information from. Defaults to `role`

## `bundle_roles`

Right now this is hardcoded to specify `no_release: true` on machines that don't have a role in the `bundle_roles` variable. This is really ugly, and very bundler specific, I am aware. I would love to see capistrano implement a `release_roles` variable that can be set to specify exactly which roles should get the release, but that hasn't yet been done. I may push this down into the puppet resource, and then by default if any resource has `no_release => false`, then that machine won't get release, but that will come in a later version (and hopefully an accompanying puppet module)
