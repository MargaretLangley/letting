def notice_new id: nil,
              instruction: 'Fill form',
              clause: 'This is useful',
              proxy: 'Filled'
  Notice.new id: id,
             instruction: instruction,
             clause: clause,
             proxy: proxy
end

def notice_create(id: nil,
              instruction: 'Fill form',
              clause: 'This is useful',
              proxy: 'Filled')
  Notice.create! id: id,
                 instruction: instruction,
                 clause: clause,
                 proxy: proxy
end
