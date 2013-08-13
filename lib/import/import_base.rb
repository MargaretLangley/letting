require_relative 'import_contact'
module DB
  class ImportBase
    include ImportContact
    attr_reader :contents
    attr_reader :patch_contents
    attr_reader :patch_models

    def initialize contents, patch_contents
      @contents = contents
      @patch_contents = patch_contents
      @patch_models = []
    end

    def self.import contents, patch_contents = []
      new(contents, patch_contents).do_it
    end

    def prepare_model_for_import row, model_class
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

      def none_matching_entities_error_message model, patch_model
        "Cannot match #{model.class} #{patch_model.human_id} names." +
        "between the loading data and the patch data." +
        " Until '#{patch_model.entities[0].name}' " +
        "is the same as '#{model.entities[0].name}' we cannot patch the address data."
      end
  end
end