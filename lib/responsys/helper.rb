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

    def self.build(schema)
      builder = Builder::XmlMarkup.new
      build_xml_from_schema(schema, builder)
    end

    def self.build_xml_from_schema(schema, builder)
      return unless schema.is_a?(Hash)
      schema.each do |key,value|
        if value.is_a?(Hash)
          builder.tns key do
            build_xml_from_schema(value, builder)
          end
        else
          if value == "fieldList"
            builder.tns value.to_sym, key.to_s
          else
            builder.tns key, value
          end
        end
      end
      builder
    end

    def self.build_retrieve_message(email, folder, object, *args)
      schema = { list: { folderName: folder, objectName: object},
        queryColumn: "EMAIL_ADDRESS"
      }
      args.each do |field_list_name|
        schema[field_list_name.to_sym] = "fieldList"
      end

      schema[:idsToRetrieve] = email

      message = build(schema)
      clean_message(message)
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

    def self.clean_message(message)
      message.to_s.gsub("<to_s/>", "")
    end
  end
end
