#
# Two types of DueOn
# OnDate   Day 1-31, Month 1-12
# PerMonth  Day 1-31, Month -1   (DueOn::PerDate)
#
# If a charge happens on a few dates in the year you use a number of OnDates
# If a charge occurs on each month then you use a PerDate.
# To create PerMonth DueOns we pass a dueon with a Day 1-31 and Month -1 (DueON::PerDate)
# As long as this is different from the current due on we delete all the other DueOns in
# the collection (including the PerMonth DueOn) and replace it with 12 onDate DueOns, one
# for each month.
#
module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, -> { order(:created_at) }, dependent: :destroy do
      def prepare
        (self.size...MAX_DISPLAYED_DUE_ONS).each { self.build }
      end

      def empty?
        self.all?(&:empty?)
      end

      def per_month?
        max_due_ons || has_per_month_due_on?
      end

      def per_month
        if per_month?
          DueOn.new day: first_day_or_empty, month: DueOn::PER_MONTH
        else
          DueOn.new day: '', month: ''
        end
      end

      def between? date_range
        self.detect{ |due_on| due_on.between? date_range }.present?
      end

      def make_date_between date_range
        self.detect{ |due_on| due_on.between? date_range }.make_date
      end


      def clean_up_form
        destruction_if :empty?
        destruction_if :persisted? if change_due_on?
        if has_per_month_due_on?
          assign_per_month per_month_due_on.day
          destruction_if :per_month?
        end
      end

    private

      def change_due_on?
        self.reject(&:marked_for_destruction?).detect(&:new_record?).present?
      end

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

      def first_day_or_empty
        self.first.present? ? self.first.day : ''
      end

      def assign_per_month day
        (1..MAX_DUE_ONS).each {|month| self.build day: day, month: month }
      end

    end

  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
