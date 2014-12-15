require 'puppetdb'
require 'set'

module Capistrano
  class PuppetDB
    def self.build_serverlist
      stage = fetch(:stage)
      tag = fetch(:puppetdb_query_tag) || stage
      role_parameter = fetch(:puppetdb_role_param) || 'role'
      query_resource_type = fetch(:puppetdb_query_resource_type)
      puppetdb_server = fetch(:puppetdb_server)

      client = ::PuppetDB::Client.new({:server => puppetdb_server})

      resource = ::PuppetDB::Query[:'=', 'type', query_resource_type]
      resource_tag = ::PuppetDB::Query[:'=', 'tag', tag]

      server_map = client.request('resources',resource.and(resource_tag)).data.inject({}) do |hashmap, role_resource|
        hashmap[role_resource['certname']] ||= Set.new
        hashmap[role_resource['certname']] << role_resource['parameters'][role_parameter]
        hashmap
      end

      server_map.each do |certname, role_list|
        no_release = true
        if !(role_list & fetch(:bundle_roles)).empty?
          no_release = false
        end
        server certname, user: 'rails', roles: role_list.to_a, primary: true, no_release: no_release
      end
    end
  end
end

load File.expand_path('../tasks/puppetdb.cap', __FILE__)
