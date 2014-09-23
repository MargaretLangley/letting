def product_new \
  charge_type: 'Rent',
  date_due: '2014-06-07',
  amount: 30.05,
  range: '30/9/2010 to 25/3/20011'

  Product.new charge_type: charge_type,
              date_due: date_due,
              amount: amount,
              range: range
end
