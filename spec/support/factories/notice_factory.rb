def notice_new id: nil,
               instruction: 'ins1',
               fill_in: 'This is useful',
               sample: 'Filled'
  Notice.new id: id,
             instruction: instruction,
             fill_in: fill_in,
             sample: sample
end

def notice_create id: nil,
                  instruction: 'ins1',
                  fill_in: 'This is useful',
                  sample: 'Filled'
  Notice.create! id: id,
                 instruction: instruction,
                 fill_in: fill_in,
                 sample: sample
end
