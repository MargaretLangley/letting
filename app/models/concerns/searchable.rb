module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(options={})
      self.as_json(
        include: {
                   address: {},
                   entities: { methods: [:full_name], only: [:full_name] },
                   agent: { methods: [:address_lines, :full_name], only: [:adress_lines, :full_name]}
                 })
    end
  end
end