module RequestSchema
  def retrieve_information_by_email_schema(folder, object, *args)
    schema = { list: { folderName: folder, objectName: object},
      queryColumn: "EMAIL_ADDRESS"
    }
    args.each do |field_list_name|
      schema[field_list_name.to_sym] = "fieldList"
    end

    schema[:idsToRetrieve] = email
    schema
  end
end
