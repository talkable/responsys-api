require 'spec_helper.rb'

describe RequestBuilder do
  let(:member) { Member.new('morgan@thredup.com') }

  context '#build' do
    it 'should take a hash and build an xml message for Savon' do
      schema = { :list => { :folderName => "foo", :objectName => "bar" },
                      :queryColumn => "EMAIL_ADDRESS", :EMAIL_PERMISSION_STATUS_ => "fieldList",
                      :idsToRetrieve => "morgan@thredup.com" }
      expectation = "<tns:list><tns:folderName>foo</tns:folderName>"\
                    "<tns:objectName>bar</tns:objectName></tns:list>"\
                    "<tns:queryColumn>EMAIL_ADDRESS</tns:queryColumn>"\
                    "<tns:fieldList>EMAIL_PERMISSION_STATUS_</tns:fieldList>"\
                    "<tns:idsToRetrieve>morgan@thredup.com</tns:idsToRetrieve>"

      expect(member.build(schema)).to eql(expectation)
    end
  end
end
