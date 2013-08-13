require_relative 'import_base'
require_relative 'import_contact'

module DB
  class ImportClient < ImportBase

    def do_it

      contents.each_with_index do |row, index|

        client = Client.where(human_id: row[:human_id]).first_or_initialize
        client.prepare_for_form

        client.assign_attributes human_id: row[:human_id]

        import_contact client, row
        clean_contact client

        still_running index

        unless client.save!
          puts "human_id: #{row[:human_id]} -  #{client.errors.full_messages}"
        end
      end
    end

    def address_type contactable
      'FlatAddress'
    end

  end
end