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
  # model_prepared, but otherwise mostly use the defaults.
  #
  ####
  #
  class ImportBase
    include ImportContact
    attr_accessor :row

    def self.import contents, patch = nil
      new(contents, patch).import_loop
    end

    def import_loop
      @contents.each_with_index do |row, index|
        self.row = row
        import_row
        show_running index
      end
    end

    def import_row
      model_prepared
      model_assignment
      model_patched if @patch
      model_saved || show_error
    end

    protected

    def initialize klass, contents, patch
      @klass = klass
      @contents = contents
      @patch = patch
    end

    def model_prepared
      @model_to_assign = first_or_initialize_model @klass
      @model_to_assign.prepare_for_form
    end

    def first_or_initialize_model model_class
      find_parent(model_class).first_or_initialize
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

    def parent_model model_class
      model = find_parent(model_class).first
      fail_parent_record_not_found model_class if model.nil?
      model
    end

    def find_parent model_class
      model_class.where human_ref: row[:human_ref]
    end

    private

    def fail_parent_record_not_found model_class
      fail ActiveRecord::RecordNotFound, no_parent_message(model_class)
    end

    def no_parent_message model_class
      "#{model_class} human_ref: #{row[:human_ref]} - Not found"
    end

    def show_error
      output_error(model_to_save)
    end

    def show_running index
      print '.' if on_100th_iteration index
    end

    def on_100th_iteration index
      index % 100 == 0 && index != 0
    end

    def output_error model
      puts "human_ref: #{row[:human_ref]} -  #{model.errors.full_messages}"
    end
  end
end
