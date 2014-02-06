require_relative '../modules/method_missing'
require_relative 'errors'

module DB
  class EntityRow
    def initialize title, initials, name
      @title = top_punctuation(title).strip
      @initials = initials.strip
      @name = tail_punctuation(name).strip
    end

    def type
      person? ? 'Person' : 'Company'
    end

    def title
      person? ? @title : ''
    end

    def initials
      person? ? @initials : ''
    end

    def name
      person? ? @name : [@initials, @name].join(' ')
    end

    def attributes
      {
        entity_type: type,
        title: title,
        initials: initials,
        name: name,
      }
    end

    private

    def person?
      (@title.present? || @initials.present?) && @name.exclude?('Ltd')
    end

    def top_punctuation s
      s.sub(/^[,&]?/, '')
    end

    def tail_punctuation s
      s.sub(/[,&]?$/, '')
    end
  end
end