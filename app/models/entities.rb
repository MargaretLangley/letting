####
#
# Entities
#
# Why does this class exist?
#
# Adds methods to an association of entities; entities hold
# either a person or company name.
#
# How does this fit into the larger system?
#
# Part of the Contact module which is used in a number of classes
# - property, client and billing profile. It holds a collection
# of entity objects.
####
#
module Entities
  extend ActiveSupport::Concern
  included do
    has_many :entities, -> { order(:created_at) },
                        dependent: :destroy, as: :entitieable do
      def prepare
        (size...MAX_ENTITIES).each { build }
        each { |entity| entity.prepare }
      end

      def clean_up_form
        destruction_if :empty?
      end

      def destroy_all
        destruction_if :all?
      end

  private

      def destruction_if matcher
        select(&matcher).each { |entity| mark_entity_for_destruction entity }
      end

      def mark_entity_for_destruction entity
        entity.mark_for_destruction
      end
    end
  end
  MAX_ENTITIES = 2
end
