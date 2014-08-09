module RequestBuilder
  def build(schema)
    builder = Builder::XmlMarkup.new
    message = build_xml_from_schema(schema, builder)
    clean_message(message)
  end

  private

  def build_xml_from_schema(schema, builder)
    return unless schema.is_a?(Hash)
    schema.each do |key,value|
      if value.is_a?(Hash)
        builder.tns key do
          build_xml_from_schema(value, builder)
        end
      else
        if %w(fieldList fieldNames fieldValues).include? value
          builder.tns value.to_sym, key.to_s
        else
          builder.tns key, value
        end
      end
    end
    builder
  end

  def clean_message(message)
    message.to_s.gsub("<to_s/>", "")
  end
end
