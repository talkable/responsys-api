require "responsys/configuration"
require "savon"
require "responsys/helper"
require "responsys/api/all"
require "responsys/api/object/all"

module Responsys
  module Api
    class Client
      include Responsys::Api::All

      attr_accessor :credentials, :client, :session_id, :jsession_id, :header

      AVAILABLE_SETTINGS = %i{wsdl endpoint namespace raise_errors proxy headers open_timeout read_timeout
                              ssl_verify_mode ssl_version ssl_cert_file ssl_cert_key_file ssl_ca_cert_file ssl_cert_key_password
                              convert_request_keys_to soap_header element_form_default env_namespace namespace_identifier namespaces
                              encoding soap_version basic_auth digest_auth wsse_auth wsse_timestamp ntlm strip_namespaces
                              convert_response_tags_to logger log_level log filters pretty_print_xml}

      def self.instance
        @@instance ||= new(Responsys.configuration.settings)
      end

      def initialize(settings)
        settings = settings.dup
        settings[:element_form_default] = :qualified

        @credentials = {
          username: settings[:username],
          password: settings[:password]
        }

        if settings[:debug]
          settings.merge(log_level: :debug, log: true, pretty_print_xml: true)
        end

        @client = Savon.client(filter_settings settings)

        login
      end

      def api_method(action, message = nil, response_type = :hash)
        begin
          response = run_with_credentials(action, message, jsession_id, header)

          case response_type
          when :result
            Responsys::Helper.format_response_result(response, action)
          when :hash
            Responsys::Helper.format_response_hash(response, action)
          end

        rescue Exception => e
          error_response = Responsys::Helper.format_response_with_errors(e)

          if error_response[:error][:code] == "INVALID_SESSION_ID"
            login
            api_method(action, message, response_type)
          else
            error_response
          end
        end
      end

      def available_operations
        @client.operations
      end

      private

      def run(method, message)
        @client.call(method.to_sym, message: message)
      end

      def run_with_credentials(method, message, cookie, header)
        @client.call(method.to_sym, message: message, cookies: cookie, soap_header: header)
      end

      def filter_settings(settings)
        settings[:ssl_version] = :TLSv1 unless settings[:ssl_version]
        settings.select { |k,v| k.to_sym != :username && k.to_sym != :password && AVAILABLE_SETTINGS.include?(k.to_sym) }
      end
    end
  end
end
