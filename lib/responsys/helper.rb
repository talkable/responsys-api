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

    def self.build_retrieve_message(email, folder, object, *args)
      builder = Builder::XmlMarkup.new

      builder.tns :list do
        builder.tns :folderName, folder
        builder.tns :objectName, object
      end

      builder.tns :queryColumn, "EMAIL_ADDRESS"
      args.each do |field_list_name|
        builder.tns :fieldList, field_list_name
      end
      builder.tns :idsToRetrieve, email
      return clean_message(builder)
    end

    def self.clean_message(message)
      message.to_s.gsub("<to_s/>", "")
    end
  end
end
