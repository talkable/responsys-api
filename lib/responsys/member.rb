require "#{Dir.pwd}/lib/responsys/request_builder"
require "#{Dir.pwd}/lib/responsys/request_schema"

class Member
  include RequestBuilder
  include RequestSchema

  attr_reader :email
  attr_accessor :connection

  def initialize(email)
    @email = email
    @connection = ResponsysApi.new
  end

  def subscribed?(folder, object)
    response = retrieve_information_by_email(folder, object, "EMAIL_PERMISSION_STATUS_")
    response[:record_data][:records][:field_values] == "I"
  end

  def unsubscribe(folder, object)
   subscription_call(folder, object, true)
  end

  def subscribe(folder, object)
   subscription_call(folder, object, false)
  end

  private

  # use args to specify user information you'd like to retrieve
  def retrieve_information_by_email(folder, object, *args)
    schema = retrieve_information_by_email_schema(folder, object, *args)
    message = build(schema)

    connection.api_method("retrieve_list_members", message)
  end

  def subscription_call(folder, object, subscription_status)
   schema = subscription_schema(folder, object, subscription_status)
   message = build(schema)

   connection.api_method("merge_list_members_riid", message)
  end
end
