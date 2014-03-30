module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    def as_indexed_json(options={})
      self.as_json(
        include: { address: { }, entities: { }
                 })
    end
  end
end