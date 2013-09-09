module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, -> { order('created_at ASC') }, dependent: :destroy do
      def prepare
        (self.size...MAX_DUE_ONS).each { self.build }
      end

      def empty?
        self.all?(&:empty?)
      end

      def per_month?
        max_due_ons || has_per_month_due_on?
      end

      def per_month
        DueOn.new day: first_day, month: first_month
      end

      def clean_up_form
        assign_per_month if has_per_month_due_on?
        destruction_if :empty?
      end
    private
      def destruction_if matcher
        self.select(&matcher).each {|due_on| mark_due_on_for_destruction due_on }
      end

      def mark_due_on_for_destruction due_on
        due_on.mark_for_destruction
      end

      def max_due_ons
        self.reject(&:empty?).size == MAX_DUE_ONS
      end

      def has_per_month_due_on?
        self.detect(&:per_month?).present?
      end

      def per_month_due_on
        self.detect(&:per_month?)
      end

      def first_day
        if per_month?
          self.first.nil? ? nil : self.first.day
        else
          ''
        end
      end

      def first_month
        if per_month?
          self.first.nil? ? nil : DueOn::PER_MONTH
        else
          ''
        end
      end

      def assign_per_month
        day = per_month_due_on.day
        self.each.with_index{|due_on,month| due_on.update day: day, month: month + 1 }
      end
    end
  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
