module Entities
  extend ActiveSupport::Concern
  included do
    has_many :entities, -> { order('created_at ASC') }, dependent: :destroy, as: :entitieable do
      def prepare
         self << Company.new if self.reject(&:person?).empty?
        (self.size...MAX_ENTITIES).each { self << Person.new }
      end

      def clean_up_form
        destruction_if :empty?
      end

      def remove_form
        destruction_if :all?
      end
    private
      def destruction_if matcher
        self.select(&matcher).each {|entity| mark_entity_for_destruction entity }
      end

        def mark_entity_for_destruction entity
          entity.mark_for_destruction
        end
    end
  end
  MAX_ENTITIES = 3
end