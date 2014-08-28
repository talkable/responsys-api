require "responsys/api/all"

module Responsys
  module Repository
    include Responsys::Api

    @@options = {}
    @@clients = {}

    def self.register_client(identifier, options)
      @@options.store identifier, options
    end

    def self.get(identifier)
      @@clients.fetch identifier do
        @@clients.store identifier, Client.new(@@options[identifier])
      end
    end
  end
end
