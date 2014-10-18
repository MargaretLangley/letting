# # Advance & arrears
# # Advance and arrears - gets dates turns them into periods
# # indexes the period on either the start or end date
# #
# # FixedTerm
# # * periods cannot be calculated from the repeat_dates
# # * Use Repeat_dates to find matching periods.
# #
# # How to get period information from persistent store
# # 1) fixed_term table with id and up to 4 columns for dates to match on
# # 2) fixed_term_period with:
# #      - FK - fixed_term table foreign key
# #      - due_date - date which the charge becomes debited.
# #      - period, two dates, which is associated with the due_date
# #
# # When you query you have a billed_date and it matches the due_date
# # This returns the periods.

# class FixedTerm
#   attr_reader :periods

#   def initialize(repeat_dates:)
#     @billed_dates_in_year = repeat_dates
#     @periods = advance_periods unless @billed_dates_in_year.empty?
#     byebug
#   end

#   def march
#     { }
#     26.12.2014—24.6.2015
#     25.6.2014—25.12,2014
#   end

#   private

#   # Advance range pairs
#   # Take two pairs of dates and make pairings
#   #
#   def advance_periods(advance_start: @billed_dates_in_year)
#     advance_start.zip(advance_end)
#   end

#   # Creating the end pairs for advance date ranges.
#   # @billed_dates_in_year: [E, F, G, H]
#   #
#   # Begin With:  E       F       G       H
#   # End   With:  F -1D   G -1D   H -1D   E -1D +1Y
#   def advance_end
#     advance = Marshal.load(Marshal.dump(@billed_dates_in_year))
#                      .rotate(1).map(&:yesterday)
#     advance[-1] = advance[-1].next_year
#     advance
#   end
# end
