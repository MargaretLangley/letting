require_relative 'import_contact'
module DB
  class ImportBase
    include ImportContact
    attr_reader :contents
    attr_reader :patch

    def initialize contents, patch
      @contents = contents
      @patch = patch
    end

    def self.import contents, patch = nil
      new(contents, patch).do_it
    end

    def model_prepared_for_import row, model_class
      model = find_or_initialize_model row, model_class
      model.prepare_for_form
      model
    end


    private

      def find_or_initialize_model row, model_class
        model_class.where(human_id: row[:human_id]).first_or_initialize
      end

      def output_still_running index
        # if a long import. Put a dot every 100 but not the first as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0
      end

      def output_error row, model
        puts "human_id: #{row[:human_id]} -  #{model.errors.full_messages}"
      end

  end
end