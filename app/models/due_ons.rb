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
module DueOns
  extend ActiveSupport::Concern
  included do
    has_many :due_ons, -> { order(:created_at) }, dependent: :destroy do

      def between? date_range
        find { |due_on| due_on.between? date_range }.present?
      end

      def make_date_between date_range
        find { |due_on| due_on.between? date_range }.make_date
      end

      def prepare
        (size...MAX_DISPLAYED_DUE_ONS).each { build }
      end

      def clear_up_form
        clear_up_all_children
        switch_to_a_due_on_for_each_month if per_month_due_on
        destruction_if :per_month? if per_month_due_on
      end

      def empty?
        self.all?(&:empty?)
      end

      def per_month?
        max_due_ons || per_month_due_on
      end

      def has_new_due_on?
        reject(&:empty?).find(&:new_record?)
      end

  private

      def clear_up_all_children
        each { |due_on| due_on.clear_up_form self }
      end

      def destruction_if matcher
        select(&matcher)
        .each { |due_on| mark_due_on_for_destruction due_on }
      end

      def mark_due_on_for_destruction due_on
        due_on.mark_for_destruction
      end

      def max_due_ons
        reject(&:empty?).size == MAX_DUE_ONS
      end

      def per_month_due_on
        find(&:per_month?)
      end

      def switch_to_a_due_on_for_each_month
        build_due_on_for_each_month_of_year per_month_due_on.day
      end

      def build_due_on_for_each_month_of_year day
        (1..MAX_DUE_ONS).each { |month| build day: day, month: month }
      end

    end

  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
