require_relative 'contact_fields'
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
  # 3. Any patches are applied - for import data that is plain wrong but
  #    is not going to be fixed in the source database.
  # 4. Save the model
  #
  # The derived classes supply model_assignment and override the
  # model_prepared, but otherwise mostly use the defaults.
  #
  # Errors do not go to logger
  # rubocop: disable Rails/Output
  #
  ####
  #
  class ImportBase
    attr_accessor :row

    # contents - data to be imported - array of arrays indexed
    #            by row no and header symbols.
    # range    - the rows to be imported, default nil
    #
    def self.import(contents, range: 1..100_000)
      new(contents, range).import_loop
    end

    # Imports, builds or assigns application objects
    #
    def import_loop
      @contents.each_with_index do |file_row, index|
        begin
          self.row = file_row
          import_row if allowed?
          show_running index
        rescue => e
          warn "Exception: #{e.message}"
          next
        end
      end
    end

    def import_row
      model_prepared
      model_assignment
      model_to_save.save || show_error
    end

    def allowed?
      !filtered?
    end

    def filtered?
      false
    end

    protected

    def initialize klass, contents, range
      @klass = klass
      @contents = contents
      @range = range
    end

    def model_prepared
      @model_to_assign = find_model(@klass).first_or_initialize
    end

    private

    def find_model _model_class
      fail NotImplementedError
    end

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
