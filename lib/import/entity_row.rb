require_relative '../modules/method_missing'
require_relative 'errors'

module DB
  class EntityRow
    attr_reader :title, :initials, :name
    def initialize title, initials, name
      @title = top_punctuation(title).strip
      @initials = initials.strip
      @name = tail_punctuation(name).strip
    end

    def person?
      ( title.present? || initials.present?) && title.exclude?('Ltd')
    end

    private

    def top_punctuation s
      s.sub(/^[,&]?/, '')
    end

    def tail_punctuation s
      s.sub(/[,&]?$/, '')
    end
  end
end