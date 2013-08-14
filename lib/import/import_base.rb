require_relative 'import_contact'
module DB
  class ImportBase
    include ImportContact
    attr_reader :klass
    attr_reader :contents
    attr_reader :patch

    def self.import contents, patch = nil
      new(contents, patch).import_rows_loop
    end

    def model_prepared_for_import row
      model = find_or_initialize_model row, klass
      model.prepare_for_form
      model
    end



    def import_rows_loop
      contents.each_with_index do |row, index|
        model = model_prepared_for_import row
        model_assigned_row_attributes model, row
        patch.patch_model model if patch
        unless model.save
          output_error row, model
        end
        output_still_running index
      end
    end

    private

      def initialize klass, contents, patch
        @klass = klass
        @contents = contents
        @patch = patch
      end


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