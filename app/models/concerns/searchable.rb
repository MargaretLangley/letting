module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    # collection is pluraized version of the model_name
    index_name [Rails.env, model_name.collection.gsub(/\//, '-')].join("_")

    settings(
      index: {
        analysis: {
          filter: {
            nGram_filter: {
              type: "nGram",
              min_gram: 2,
              max_gram: 15,
              token_chars: [:letter, :digit, :punctuation, :symbol]
            }
          },
          analyzer: {
            nGram_analyzer: {
              type: "custom",
              tokenizer: "whitespace",
              filter: [:lowercase, :asciifolding, :nGram_filter]
            },
            whitespace_analyzer: {
              type: "custom",
              tokenizer: "whitespace",
              filter: [:lowercase, :asciifolding]
            }
          }
        },
        number_of_shards: 1
      }
    )

    mapping _all: { index_analyzer: :nGram_analyzer, search_analyzer: :whitespace_analyzer } do
      indexes :human_ref, type: :integer, boost: 2.0, index: :not_analyzed
      indexes :occupier, type: :string
      indexes :address do
        indexes :created_at, index: :not_analyzed
        indexes :updated_at, index: :not_analyzed
      end

      indexes :created_at, index: :not_analyzed
      indexes :updated_at, index: :not_analyzed
    end

    def self.search(query)
      __elasticsearch__.search(
        query: {
          match: {
            _all: {
              query: query,
              operator: "and"
            }
          }
        }
      )
    end
  end
end

# Console Management
#
# Create
# Property.__elasticsearch__.create_index! force: true
# Create None-standard index
# Property.__elasticsearch__.client.indices.create  index: Property.index_name,  body: { settings: Property.settings.to_hash, mappings: Property.mappings.to_hash }
#
# Read
# GET /properties/_settings
# Property.settings.to_hash
# GET /properties/_mapping
# pp Property.mappings.to_hash
#
# Update (Refresh)
# Property.__elasticsearch__.refresh_index!
#
# Delete
# Property.__elasticsearch__.delete_index!

# Import Data
# Property.import