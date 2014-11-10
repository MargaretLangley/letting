def guide_new id: nil,
              template_id:'2',
              instruction: 'Your instruction',
              fillin: 'This is useful',
              sample: 'Filled top'
  Guide.new id: id,
            template_id: template_id,
            instruction: instruction,
            fillin: fillin,
            sample: sample
end

def guide_create id: nil,
                 template_id:'2',
                 instruction: 'Your instruction',
                 fillin: 'This is useful',
                 sample: 'Filled top'
  Guide.create! id: id,
                template_id: template_id,
                instruction: instruction,
                fillin: fillin,
                sample: sample
end
