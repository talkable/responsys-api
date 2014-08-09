module RequestSchema
  def retrieve_information_by_email_schema(folder, object, *args)
    schema = { list: { folderName: folder, objectName: object },
      queryColumn: "EMAIL_ADDRESS"
    }
    args.each do |field_list_name|
      schema[field_list_name.to_sym] = "fieldList"
    end

    schema[:idsToRetrieve] = email
    schema
  end

  def subscription_schema(folder, object, subscription_status)
    subscription_field_value = subscription_status ? "O" : "I"
    schema = { list: { folderName: folder, objectName: object },
              recordData: { :EMAIL_ADDRESS_ => "fieldNames", :EMAIL_PERMISSION_STATUS_ => "fieldNames",
                            records: { "#{email}" => "fieldValues", "#{subscription_field_value}" => "fieldValues" } },
              mergeRule: { insertOnNoMatch: "", updateOnMatch: "REPLACE_ALL",
                matchColumnName1: "EMAIL_ADDRESS_", matchColumnName2: "", matchColumnName3: "",
                matchOperator: "", optinValue: "", optoutValue: "", htmlValue: "",
                textValue: "", rejectRecordIfChannelEmpty: "", defaultPermissionStatus: "" }
            }
  end
end
