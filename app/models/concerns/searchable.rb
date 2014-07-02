module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(options={})
      self.as_json(
        methods: :occupier,
        include: {
                   address: {},
                   agent: { methods: [:address_lines, :full_name], only: [:address_lines, :full_name]}
                 })
    end

    def self.search(query)
      __elasticsearch__.search(
        {
          query: {
            query_string: {
              query: query,
              default_operator: 'AND'
            }
          }
        }
      )
    end
  end
end