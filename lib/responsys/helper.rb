class ResponsysApi
  module ResponseHelper
    def self.format_response(response, action)
      response.body[("#{action}_response").to_sym][:result]
    end
  end

  module RequestHelper
    def self.format_request
      # we will probably need to specifically format some of our requests
    end
  end
end
