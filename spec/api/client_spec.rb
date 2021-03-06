require "spec_helper.rb"
require "responsys/api/client"
require "singleton"

describe Responsys::Api::Client do
  after do
    Responsys::Api::Client.class_variable_set(:@@instance, nil)
  end

  context "expired session" do
    before(:example) do
      allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil)

      Responsys::Api::Client.instance.instance_variable_set(:@session_id, "fake_session_id")
      Responsys::Api::Client.instance.instance_variable_set(:@jsession_id, HTTPI::Cookie.new("jsessionid=fakejsessionid; Path=/; HttpOnly"))
      Responsys::Api::Client.instance.instance_variable_set(:@header, { SessionHeader: { sessionId: "fake_session_id" } })
    end

    it "should ask for a new session" do
      VCR.use_cassette("api/client/expired_session") do
        expect_any_instance_of(Responsys::Api::Client).to receive(:login).exactly(1).times.and_call_original
        result = Responsys::Api::Client.instance.api_method(:list_folders)

        expect(result[:status]).to eq("ok")
      end
    end

    it "should rerun the request with a new session id" do
      VCR.use_cassette("api/client/expired_session") do
        expect_any_instance_of(Responsys::Api::Client).to receive(:login).exactly(1).times.and_call_original

        expect(Responsys::Api::Client.instance.header[:SessionHeader][:sessionId]).to eq("fake_session_id")

        Responsys::Api::Client.instance.api_method(:list_folders)

        expect(Responsys::Api::Client.instance.header[:SessionHeader][:sessionId]).to eq("5GXdGHHKOLqsf4ukCpwQYz3B0b")
      end
    end

  end

  context "Authentication" do
    let(:savon_client) { double("savon client") }
    before do
      @credentials = { username: "your_responsys_username", password: "your_responsys_password" }
    end

    it "should set the credentials" do
      allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil)

      responsys = Responsys::Api::Client.instance

      expect(responsys.credentials).to eq({ username: "your_responsys_username", password: "your_responsys_password" })
    end

    context "login" do
      before do
        response = double("response")

        cookies = %w(fake_jsession_id)
        body = {
          login_response: {
            result: {
              session_id: "fake_session_id"
            }
          }
        }

        allow(response).to receive(:body).and_return(body)
        allow(response).to receive(:http).and_return(double("cookies", cookies: cookies))

        allow_any_instance_of(Responsys::Api::Client).to receive(:run).with("login", @credentials).and_return(response) #Verification of credentials
      end

      it "should set the session ids" do
        instance = Responsys::Api::Client.instance #Get it

        expect(instance.header).to eq({ SessionHeader: { sessionId: "fake_session_id" } }) #Test the ids are right
        expect(instance.jsession_id).to eq("fake_jsession_id")
      end
    end

    context "logout" do
      before do
        allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil) #Avoid credentials checking
      end

      it "should logout" do
        instance = Responsys::Api::Client.instance #Get it

        allow(Responsys::Helper).to receive(:format_response_hash).with(any_args) #We dont want to parse the response
        expect_any_instance_of(Savon::Client).to receive(:call).with(:logout, anything) #Check the call is actually being done

        instance.logout
      end
    end
  end

  context "Savon client options" do
    it "accpets additional options" do
      allow_any_instance_of(Responsys::Api::Client).to receive(:login).and_return(nil)

      client = Responsys::Api::Client.new(
          username: "your_responsys_username",
          password: "your_responsys_password",
          wsdl: "https://wsxxxx.responsys.net/webservices/wsdl/ResponsysWS_Level1.wsdl",
          debug: false,
          read_timeout: 5
        )

      expect(client.instance_variable_get(:@client).globals[:read_timeout]).to eq(5)
    end
  end
end
