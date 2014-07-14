#####
#
# DueOns
#
# Dates on which a charge becomes due, billable.
#
# Charges are queried if they are billable within a range of dates.
# The DueOns allows the associated charge to answer the query.
# The DueOns hold a collection of DueOn - each one has a date that
# a charge becomes due - the dueons, plural, when queried search the
# dueon, singular to find any matching dueon.
#
# Two types of DueOn
# OnDate   Day 1-31, Month 1-12
# PerMonth  Day 1-31, Month -1   (DueOn::PerDate)
#
# If a charge happens on a few dates in the year you use a number of OnDates
# If a charge occurs on each month then you use a PerDate.
# To create PerMonth DueOns we pass a dueon with
# a Day 1-31 and Month -1 (DueON::PerDate)
# As long as this is different from the current due on we delete
# all the other DueOns in the collection (including the PerMonth DueOn)
# and replace it with 12 onDate DueOns, one for each month.
#
####
#
module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, -> { order(:created_at) }, dependent: :destroy do

      def due_dates date_range
        ordered_by_occurrence.select { |due_on| due_on.between? date_range }
                              .map { |due_on| due_on.make_date }
      end

      def prepare
        (size...MAX_DISPLAYED_DUE_ONS).each { build }
      end

      def clear_up_form
        clear_up_all
        to_monthly if monthly_due_on
        destruction_if :monthly? if monthly_due_on
      end

      def empty?
        self.all?(&:empty?)
      end

      def monthly?
        max_due_ons || monthly_due_on
      end

      def new?
        reject(&:empty?).find(&:new_record?)
      end

      private

      def clear_up_all
        each { |due_on| due_on.clear_up_form self }
      end

      def destruction_if matcher
        select(&matcher).each(&:mark_for_destruction)
      end

      def max_due_ons
        reject(&:empty?).size == MAX_DUE_ONS
      end

      def monthly_due_on
        find(&:monthly?)
      end

      def to_monthly
        (1..MAX_DUE_ONS)
        .each { |month| build day: monthly_due_on.day, month: month }
      end

      def ordered_by_occurrence
        sort { |a, b| a.make_date <=> b.make_date }
      end
    end

    validate :due_ons_size

    def due_ons_size
      errors.add :due_ons, 'Too many due_ons' if persitable_due_ons.size > 12
    end

    def persitable_due_ons
      due_ons.reject(&:marked_for_destruction?)
    end
  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
