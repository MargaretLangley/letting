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
    has_many :due_ons, -> { order('created_at ASC') }, dependent: :destroy do
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

      def clean_up_form
        if has_per_month_due_on?
          new_day_for_per_month_charge = per_month_due_on.day
          destruction_if :per_month? if has_per_month_due_on?
          if new_day_for_per_month_charge != current_day_for_per_month_charge
            destruction_if :present?
            assign_per_month new_day_for_per_month_charge
          end
        else
          if self.detect(&:new_record?).present?
            destruction_if :persisted?
          end
        end
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

      def current_day_for_per_month_charge
        first_none_per_month_due_on.present? ? first_none_per_month_due_on.day : nil
      end

      def first_none_per_month_due_on
        self.reject(&:per_month?).first
      end

      def first_day_or_empty
        self.first.present? ? self.first.day : ''
      end

      def assign_per_month day
        (1..MAX_DUE_ONS).each {|month| self.build day: day, month: month }
      end
    end

    def logger_due_ons
      logger.debug "M4D: #{self.select(&:marked_for_destruction?).length} / #{self.size}"
      logger.debug "Saved"
      self.reject(&:marked_for_destruction?).each do |due_on|
        logger.debug "day: #{due_on.day} month: #{due_on.month}"
      end
      logger.debug "Marked for destruction"
      self.select(&:marked_for_destruction?).each do |due_on|
        logger.debug "day: #{due_on.day} month: #{due_on.month}"
      end
    end
  end
  MAX_DISPLAYED_DUE_ONS = 4
  MAX_DUE_ONS = 12
end
