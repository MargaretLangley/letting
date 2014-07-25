require 'spec_helper'
require_relative '../../../lib/import/file_import'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/patch'
require_relative '../../../lib/import/import_client'
require_relative '../../../lib/import/import_property'
require_relative '../../../lib/import/import_agent'

module DB
  describe 'Patch', :import do

    context 'Client' do

      def row
        %q(11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, ,Example Town,  Example County,  E10 7EX)
      end

      def different_id
        %q(12,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, Example District ,Example Town,  Example County,  E10 7EX)
      end

      def same_id
        %q(11,  Mr,  D, Example, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, Example District ,Example Town,  Example County,  E10 7EX)
      end

      def same_id_name_changed
        %q(11,  Mr,  A, Name Changed, Mrs, A N, Other, 1, ExampleHouse,  2, ) +
        %q(Example Street, Example District ,Example Town,  Example County,  E10 7EX)
      end

      it 'only patches when id are the same' do
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(different_id))
        expect(Client.first.address.district).to be_blank
      end

      it 'if import row id == patch row id - change attributes' do
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(same_id))
        expect(Client.first.address.district).to eq 'Example District'
      end

      it 'if id match but entity names are differenit it errors' do
        expect($stdout).to receive(:puts).with(/Cannot match/)
        ImportClient.import parse_client(row),
                            patch: Patch.import(Client, parse_client(same_id_name_changed))

      end
    end

    context 'Property' do

      def row
        %q(122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, ) +
        %q(11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0)
      end

      def patch_row
        %q(122, 2013-02-26 12:35:00, Mr, A N, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, Example District ,Ex Town, Ex County, E10 7EX, ) +
        %q(11,  N, GR,  H, 0, Ins, 0, 0, 0, 0, 0)
      end

      it 'works on property' do
        client_create! human_ref: 11
        ImportProperty.import parse_property(row),
                              patch: Patch.import(Property, parse_property(patch_row))
        expect(Property.first.address.district).to eq 'Example District'
      end
    end

    context 'Agent' do

      def row
        %q(122, Mr, B P, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, ,Ex Town, Ex County, E10 7EX, )
      end

      def patch_row
        %q(122, Mr, B P, Example, Mrs, A N, Other,) +
        %q(1, ExampleHouse, 2, Ex Street, Example District ,Ex Town, Ex County, E10 7EX, )
      end

      def patch_nation_row
        %q(122, Mr, B P, Example, Mrs, A N, Other,) +
        %q(,The Aparments, , Road  Panel 2, District Buzon 16, Town Dip de Zarzalico,) +
        %q(County Puerto Lumbreras,, SPAIN)
      end

      it 'works on Agent' do
        property_create! human_ref: 122
        ImportAgent.import parse_agent(row),
                           patch: Patch.import(AgentWithId,
                                               parse_agent(patch_row))
        expect(Property.first.agent.address.district).to eq 'Example District'
      end

      it 'patches nation' do
        property_create! human_ref: 122
        ImportAgent.import parse_agent(row),
                           patch: Patch.import(AgentWithId,
                                               parse_agent(patch_nation_row))
        expect(Property.first.agent.address.nation).to eq 'SPAIN'
      end
    end

    def parse_client row_string
      CSV.parse(row_string,
                headers: FileHeader.client,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end

    def parse_property row_string
      CSV.parse(row_string,
                headers: FileHeader.property,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end

    def parse_agent row_string
      CSV.parse(row_string,
                headers: FileHeader.agent,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end

    def parse_agent row_string
      CSV.parse(row_string,
                headers: FileHeader.agent_patch,
                header_converters: :symbol,
                converters: -> (field) { field ? field.strip : nil }
               )
    end
  end
end
