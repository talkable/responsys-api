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

    def self.build_unsubscribe_message(email, folder, object)
      builder = Builder::XmlMarkup.new

      # builder.tns :list do
      #   builder.tns :folderName, folder
      #   builder.tns :objectName, object
      # end
      # builder.tns :recordData do
      #   builder.tns :fieldNames,
      #   builder.tns :records do
      #     builder.tns :fieldValues,
      #   end
      # end
      # builder.tns :mergeRule do
      #   builder.tns :insertOnNoMatch,
      #   builder.tns :updateOnMatch,
      #   builder.tns :matchColumnName1,
      #   builder.tns :matchColumnName2,
      #   builder.tns :matchColumnName3,
      #   builder.tns :matchOperator,
      #   builder.tns :optinValue,
      #   builder.tns :optoutValue,
      #   builder.tns :htmlValue,
      #   builder.tns :textValue,
      #   builder.tns :rejectRecordIfChannelEmpty,
      #   builder.tns :defaultPermissionStatus,
      # end
    end
  end
end
