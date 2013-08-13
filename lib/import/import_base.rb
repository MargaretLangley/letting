require_relative 'import_contact'
module DB
  class ImportBase
    include ImportContact
    attr_reader :contents

    def initialize contents
      @contents = contents
    end

    def self.import contents
      new(contents).do_it
    end

    def still_running index
      # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
      print '.' if index % 100 == 0 && index != 0
    end

  end
end