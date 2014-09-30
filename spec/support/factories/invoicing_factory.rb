# rubocop: disable Metrics/MethodLength
def invoicing_new id: nil,
                  property_range: '1-100',
                  start_date: '2014/06/30',
                  end_date: '2014/08/30',
                  invoices: [invoice_new]
  invoicing = Invoicing.new id: id,
                            property_range: property_range,
                            start_date: start_date,
                            end_date: end_date
  invoicing.invoices = invoices if invoices
  invoicing
end

def invoicing_create id: nil,
                     property_range: '1-100',
                     start_date: '2014/06/30',
                     end_date: '2014/08/30',
                     invoices: [invoice_new]
  invoicing = Invoicing.new id: id,
                            property_range: property_range,
                            start_date: start_date,
                            end_date: end_date
  invoicing.invoices = invoices if invoices
  invoicing.save!
  invoicing
end
