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
# - property, client and agent. It holds a collection
# of entity objects.
####
#
module Entities
  extend ActiveSupport::Concern
  included do
    has_many :entities, -> { order(:created_at) }, dependent: :destroy,
                                                   as: :entitieable do

      def full_name
        reject(&:empty?).map(&:full_name).join(' & ')
      end

      def prepare
        (size...MAX_ENTITIES).each { build }
        each(&:prepare)
      end

      def clear_up_form
        each(&:clear_up_form)
      end

      def destroy_all
        each(&:destroy_form)
      end
    end
  end
  MAX_ENTITIES = 2
end
