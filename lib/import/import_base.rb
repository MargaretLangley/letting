require_relative 'import_contact'
module DB
  class ImportBase
    include ImportContact

    def model_to_save
      @model_to_save || @model_to_assign
    end

    def self.import contents, patch = nil
      new(contents, patch).import_rows_loop
    end

    def model_prepared_for_import row
      @model_to_assign = first_or_initialize_model row, @klass
      @model_to_assign.prepare_for_form
    end

    def import_rows_loop
      @contents.each_with_index do |row, index|
        model_prepared_for_import row
        model_assignment row
        @patch.patch_model @model_to_assign if @patch
        model_to_save.save || output_error(row, model_to_save)
        output_still_running index
      end
    end

    private

      def initialize klass, contents, patch
        @klass = klass
        @contents = contents
        @patch = patch
      end

      def first_or_initialize_model row, model_class
        model_class.where(human_id: row[:human_id]).first_or_initialize
      end

      def first_model row, model_class
        model = model_class.where(human_id: row[:human_id]).first
        if model.nil?
          puts "human_id: #{row[:human_id]} - Not found"
          raise ActiveRecord::RecordNotFound
        end
        model
      end

      def output_still_running index
        # if a long import. Put a dot every 100 but not the first
        # as you'll see dots in spec tests
        print '.' if index % 100 == 0 && index != 0
      end

      def output_error row, model
        puts "human_id: #{row[:human_id]} -  #{model.errors.full_messages}"
      end
  end
end
