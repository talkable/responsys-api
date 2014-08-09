module RequestSchema
  def retrieve_information_by_email_schema(folder, object, *args)
    schema = {}
    schema[:list] = {}
    schema[:list][:folderName] = folder
    schema[:list][:objectName] = object
    schema[:queryColumn] = "EMAIL_ADDRESS"

    args.each do |field_list_name|
      schema[field_list_name.to_sym] = "fieldList"
    end

    schema[:idsToRetrieve] = email
    schema
  end

  def subscription_schema(folder, object, subscription_status)
    subscription_field_value = subscription_status ? "O" : "I"

    schema = {}
    schema[:list] = {}
    schema[:list][:folderName] = folder
    schema[:list][:objectName] = object
    schema[:recordData] = {}
    schema[:recordData][:EMAIL_ADDRESS_] = "fieldNames"
    schema[:recordData][:EMAIL_PERMISSION_STATUS_] = "fieldNames"
    schema[:recordData][:records] = {}
    schema[:recordData][:records]["#{email}"] = "fieldValues"
    schema[:recordData][:records]["#{subscription_field_value}"] = "fieldValues"
    schema[:mergeRule] = {}
    schema[:mergeRule][:insertOnNoMatch] = ""
    schema[:mergeRule][:updateOnMatch] = "REPLACE_ALL"
    schema[:mergeRule][:matchColumnName1] = "EMAIL_ADDRESS_"
    schema[:mergeRule][:matchColumnName2] = ""
    schema[:mergeRule][:matchColumnName3] = ""
    schema[:mergeRule][:matchOperator] = ""
    schema[:mergeRule][:optinValue] = ""
    schema[:mergeRule][:optoutValue] = ""
    schema[:mergeRule][:htmlValue] = ""
    schema[:mergeRule][:textValue] = ""
    schema[:mergeRule][:rejectRecordIfChannelEmpty] = ""
    schema[:mergeRule][:defaultPermissionStatus] = ""
    schema
  end
end
