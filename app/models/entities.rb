module Entities
  extend ActiveSupport::Concern
  included do
    has_many :entities, -> { order(:created_at) }, dependent: :destroy, as: :entitieable do
      def prepare
        (self.size...MAX_ENTITIES).each { self.build }
        self.each {|entity| entity.prepare }
      end

      def clean_up_form
        destruction_if :empty?
      end

      def destroy_all
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
  MAX_ENTITIES = 2
end