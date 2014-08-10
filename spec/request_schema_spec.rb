require 'spec_helper.rb'

describe RequestSchema do
  let(:email){ "morgan@thredup.com" }
  let(:member){ Member.new(email) }

  context '#retrieve_information_by_email_schema' do
    it 'should return a hash in the appropriate format with the correct information' do
      expectation = { :list => { :folderName => "foo", :objectName => "bar" },
                      :queryColumn => "EMAIL_ADDRESS", :EMAIL_PERMISSION_STATUS_ => "fieldList",
                      :idsToRetrieve => "morgan@thredup.com" }

      expect(member.retrieve_information_by_email_schema('foo', 'bar', 'EMAIL_PERMISSION_STATUS_')).to eql(expectation)
    end
  end

  context '#subscription_schema' do
    it 'should return a hash in the appropriate format with the correct information' do
      expectation = { :list => { :folderName => "foo", :objectName => "bar" },
                    :recordData => { :EMAIL_ADDRESS_ => "fieldNames", :EMAIL_PERMISSION_STATUS_ => "fieldNames",
                    :records => { "morgan@thredup.com" => "fieldValues", "O" => "fieldValues" } },
                    :mergeRule => { :insertOnNoMatch => false, :updateOnMatch => "REPLACE_ALL",
                                    :matchColumnName1 => "EMAIL_ADDRESS_", :matchColumnName2 => "",
                                    :matchColumnName3 => "", :matchOperator => "", :optinValue => "",
                                    :optoutValue => "", :htmlValue => "", :textValue => "",
                                    :rejectRecordIfChannelEmpty => "", :defaultPermissionStatus => "" } }

      expect(member.subscription_schema('foo', 'bar', true, false)).to eql(expectation)
    end
  end
end
