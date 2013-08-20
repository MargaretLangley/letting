module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, dependent: :destroy do
      def prepare
        (self.size...MAX_DUE_ONS).each { self.build }
      end

      def empty?
        self.all?(&:empty?)
      end

      def clean_up_form
        destruction_if :empty?
      end
    private
      def destruction_if matcher
        self.select(&matcher).each {|due_on| mark_due_on_for_destruction due_on }
      end

      def mark_due_on_for_destruction due_on
        due_on.mark_for_destruction
      end
    end
  end
  MAX_DUE_ONS = 2
end
