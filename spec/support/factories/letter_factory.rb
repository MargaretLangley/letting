def letter_new id: nil,
               invoice_id: nil,
               template_id: 1
  Letter.new id: id,
             invoice_id: invoice_id,
             template_id: template_id
end

def letter_create id: nil,
                  invoice_id: 1,
                  template_id: 1
  Letter.create! id: id,
                 invoice_id: invoice_id,
                 template_id: template_id
end
