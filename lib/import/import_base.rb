require_relative 'contact_row'
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
    attr_accessor :row

    # contents - data to be imported - array of arrays indexed
    #            by row no and header symbols.
    # range    - the rows to be imported
    # patch    - the corrections to the contents
    #
    def self.import contents, args = {}
      new(contents, args[:range], args[:patch]).import_loop
    end

    # Imports, builds or assigns application objects
    #
    def import_loop
      @contents.each_with_index do |row, index|
        self.row = row
        import_row if allowed?
        show_running index
      end
    end

    def import_row
      model_prepared
      model_assignment
      model_patched if @patch
      model_to_save.save || show_error
    end

    def allowed?
      return true if @range.nil?
      !filtered?
    end

    def filtered?
      false
    end

    protected

    def initialize klass, contents, range, patch
      @klass = klass
      @contents = contents
      @range = range
      @patch = patch
    end

    def model_prepared
      @model_to_assign = find_model(@klass).first_or_initialize
    end

    def model_patched
      @patch.patch_model @model_to_assign
    end

    private

    def find_model! model_class
      model = find_model(model_class)
      fail_parent_record_not_found model_class if model.none?
      model
    end

    def model_to_save
      @model_to_save || @model_to_assign
    end

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
