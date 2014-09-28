def notice_new id: nil,
               template_id:'2',
               instruction: 'ins1',
               fill_in: 'This is useful',
               sample: 'Filled'
  Notice.new id: id,
             template_id: template_id,
             instruction: instruction,
             fill_in: fill_in,
             sample: sample
end

def notice_create id: nil,
                  template_id:'2',
                  instruction: 'ins1',
                  fill_in: 'This is useful',
                  sample: 'Filled'
  Notice.create! id: id,
                 template_id: template_id,
                 instruction: instruction,
                 fill_in: fill_in,
                 sample: sample
end
