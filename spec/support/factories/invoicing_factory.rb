# rubocop: disable Metrics/MethodLength
def invoicing_new id: nil,
                  property_range: '1-100',
                  period_first: '2014/06/30',
                  period_last: '2014/08/30',
                  invoices: [invoice_new]
  invoicing = Invoicing.new id: id,
                            property_range: property_range,
                            period_first: period_first,
                            period_last: period_last
  invoicing.invoices = invoices if invoices
  invoicing
end

def invoicing_create id: nil,
                     property_range: '1-100',
                     period_first: '2014/06/30',
                     period_last: '2014/08/30',
                     invoices: [invoice_new]
  invoicing = Invoicing.new id: id,
                            property_range: property_range,
                            period_first: period_first,
                            period_last: period_last
  invoicing.invoices = invoices if invoices
  invoicing.save!
  invoicing
end
