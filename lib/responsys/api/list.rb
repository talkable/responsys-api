require 'responsys/api/object/all'

module Responsys
  module Api
    module List
      include Responsys::Api::Object
      def retrieve_list_members(interactObject, queryColumn, fieldList, idsToRetrieve)
        message = {
          "list" => interactObject.to_hash,
          "queryColumn" => queryColumn,
          "fieldList" => fieldList,
          "idsToRetrieve" => idsToRetrieve
        }

        api_method(:retrieve_list_members, message)
      end

      def merge_list_members(interactObject, recordData, mergeRule=ListMergeRule.new)
        message = {
          "list" => interactObject.to_hash,
          "recordData" => recordData.to_hash,
          "mergeRule" => mergeRule.to_hash
        }

        api_method(:merge_list_members, message)
      end
    end
  end
end