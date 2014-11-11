#
# Template
#
# Text for the invoice Template id: 1 is page 1, and id: 2 is page 2.
#
# Template                          Notice (join)
# id Description    invoice_name    id  instruction            Fill In
# 1  Page 1 Invoice F & L Adams     nil
# 2  Page 2         F & L Adams     1  [Insert leaseholder]    To
#                                   2  [address of premises]   This notice is
#                                   3  [Insert date]           Requires rent
#                                   ..
#                                   7  [Insert Landlord name]  To
#

class << self

  def create_templates
    Template.create! [
      { id: 1,
        description: "Page 1 Invoice",
        invoice_name: "F & L Adams",
        phone: "1215030992",
        vat: "277 9904 95",
        heading1: "Lettings",
        heading2: "Invoice",
        advice1: "Hearby notice ",
        advice2: "Remittance Advice",
      },
      { id: 2,
        description:"Page 2",
        invoice_name: "F & L Adams",
        phone: "1215030992",
        vat: "277 9904 95",
        heading1: "Common Leasehold",
        heading2: "Notice to ",
        advice1: "NOTICE LEASES",
        advice2: "NOTES LANDLORDS",
      },
    ]

    Address.create! [
      {
        addressable_id: 1,
        addressable_type: 'Template',
        flat_no:  '',
        house_name: '',
        road_no:  '77',
        road:     'Henley Road',
        district: 'Edgbaston',
        town:     'Birmingham',
        county:   'West Midlands',
        postcode: 'B32 7NR'
      }
    ]

  end

  def create_guides
    Guide.create! [
      { id: 1,
        template_id: 2,
        instruction: "Insert leaseholder",
        fillin: "To",
        sample: "Ms Sample"
      },
      { id: 2,
        template_id: 2,
        instruction: "Address of premises",
        fillin: "This notice",
        sample: "27 High St"
      },
      { id: 3,
        template_id: 2,
        instruction: "Insert date",
        fillin: "It requires",
        sample: "21st June"
      },
      { id: 4,
        template_id: 2,
        instruction: "[State Period]",
        fillin: "Payable for period",
        sample: "20March-29th Sep",
      },
      { id: 5,
        template_id: 2,
        instruction: "[Insert Landlord name]",
        fillin: "Pay to",
        sample: "Mr Collector",
      },
      { id: 6,
        template_id: 2,
        instruction: "[Insert address]",
        fillin: "at",
        sample: "11 High Street",
      },
      { id: 7,
        template_id: 2,
        instruction: "[Insert Landlord name]",
        fillin: "To",
        sample: "CLIENT NAME",
      },

    ]
  end

end

create_templates
create_guides
