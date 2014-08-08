class Member
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

  def unsubscribe
  end

  # use args to specify user information you'd like to retrieve
  def retrieve_information_by_email(folder, object, *args)
    message = ResponsysApi::RequestHelper.build_retrieve_message(email, folder, object, *args)
    connection.api_method("retrieve_list_members", message)
  end
end
