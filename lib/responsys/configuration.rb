require 'yaml'

class ResponsysApi
  class Configuration
    APP_CONFIG = YAML.load_file("#{Dir.pwd}/lib/settings.yml")

    attr_accessor :settings
    # Put all these constants into a configurable setting hash

    def initialize
      @settings = {
        username: APP_CONFIG["username"],
        password: APP_CONFIG["password"],
        wsdl: APP_CONFIG["wsdl"],
        master_folder: APP_CONFIG["master_folder"],
        master_list: APP_CONFIG["master_list"]
      }
    end
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
