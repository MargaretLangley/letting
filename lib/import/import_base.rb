require_relative 'import_contact'
module DB
  ####
  #
  # ImportBase
  #
  # The base class for the importing models from data arrays
  #
  # All imports use this class to populate the database.
  # A model is saved with each iteration of the import loop
  # 1. The system finds and prepares the current model from the database
  #     - (if available)
  # 2. Assigns the row values to the model
  # 3. Any patches are applied - for import data that is just plain wrong but
  #    is not going to be fixed in the source database.
  # 4. Save the model
  #
  # The derived classes supply model_assignment and override the
  # model_prepared_for_import, but otherwise mostly use the defaults.
  #
  ####
  #
  class ImportBase
    include ImportContact

    def self.import contents, patch = nil
      new(contents, patch).import_loop
    end

    def import_loop
      @contents.each_with_index do |row, index|
        model_prepared_for_import row
        model_assignment row
        model_patched if @patch
        model_saved || show_error(row)
        show_running index
      end
    end

    protected

    def initialize klass, contents, patch
      @klass = klass
      @contents = contents
      @patch = patch
    end

    def first_or_initialize_model row, model_class
      model_class.where(human_ref: row[:human_ref]).first_or_initialize
    end

    def model_prepared_for_import row
      @model_to_assign = first_or_initialize_model row, @klass
      @model_to_assign.prepare_for_form
    end

    def model_patched
      @patch.patch_model @model_to_assign
    end

    def model_saved
      model_to_save.save
    end

    def model_to_save
      @model_to_save || @model_to_assign
    end

    def parent_model row, model_class
      model = model_class.where(human_ref: row[:human_ref]).first
      fail_parent_record_not_found model_class, row if model.nil?
      model
    end

    private

    def fail_parent_record_not_found model_class, row
      fail ActiveRecord::RecordNotFound, no_parent_message(model_class, row)
    end

    def no_parent_message model_class, row
      "#{model_class} human_ref: #{row[:human_ref]} - Not found"
    end

    def show_error row
      output_error(row, model_to_save)
    end

    def show_running index
      print '.' if on_100th_iteration index
    end

    def on_100th_iteration index
      index % 100 == 0 && index != 0
    end

    def output_error row, model
      puts "human_ref: #{row[:human_ref]} -  #{model.errors.full_messages}"
    end
  end
end
