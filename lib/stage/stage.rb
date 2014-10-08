require 'csv'
###
#
# StageClient
#
# Makes a staging area for client information - it takes legacy data
# and patches in any mistakes to improve the quality.
#
# The class slots into staging/clients.rake - which is more testable
# than a rake file.
#
class Stage
  attr_reader :file_name, :input, :instructions, :headers
  def initialize(file_name:, input:, instructions:, headers: nil)
    @input = input
    @instructions = instructions
    @file_name = file_name
    @headers = headers || input.headers
  end

  def stage rows: cleanse
    make_stage
    stage_array rows: rows
  end

  private

  def cleanse
    instructions.each { |instruct| instruct.cleanse originals: input.to_a }
    input.to_a
  end

  def make_stage
    FileUtils.mkdir_p File.dirname(file_name)
  end

  def stage_array(rows:)
    CSV.open file_name, 'w', write_headers: true, headers: headers do |csv|
      rows.each { |row_array| csv << row_array }
    end
  end
end
