Actors: User
Goal: Create a list of invoices to print

Main success scenario

1. System prompts to invoice properties, enter a property range.
2. User enters range to invoice and presses search button.
3. System lists the properties which will be invoiced and those that will be
   retained (billed but not invoiced) and those that will be ignored (no
   charges).
4. The user can optionally fill in invoice date and comments before creating the
   invoice.
5. The system validates, creates the invoices, and messages success.


3.a. The range excludes any property.
1. The system displays error message
2. The use case continues at step 1.

3.b. The range excludes any property that can be billed for the period.
1. The system displays error message detailing property's charges.
2. The use case continues at step 1.
