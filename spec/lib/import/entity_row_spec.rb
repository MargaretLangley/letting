require 'csv'
require 'spec_helper'
require_relative '../../../lib/import/file_header'
require_relative '../../../lib/import/entity_row'

module DB
  describe EntityRow do

    context 'entity' do
      it 'title' do
        entity = EntityRow.new 'Mr', 'A', 'Man'
        expect(entity.title).to eq 'Mr'
      end

      it 'initials' do
        entity = EntityRow.new 'Mr', 'A D', 'Man'
        expect(entity.initials).to eq 'A D'
      end

      it 'name' do
        entity = EntityRow.new 'Mr', 'A D', 'Man'
        expect(entity.name).to eq 'Man'
      end

      context 'Person' do
        it 'is recognized' do
          entity = EntityRow.new 'Mr', 'A D', 'Man'
          expect(entity).to be_person
        end
      end

      it 'leaves ampersand in middle' do
        entity = EntityRow.new 'Mr', 'A D', 'Woman & Man,'
        expect(entity.name).to eq 'Woman & Man'
      end

      it 'removes trailing ampersand' do
        entity = EntityRow.new 'Mr', 'A D', 'Man&'
        expect(entity.name).to eq 'Man'
      end

      it 'removes trailing ampersand' do
        entity = EntityRow.new 'Mr', 'A D', 'Man,'
        expect(entity.name).to eq 'Man'
      end

      it 'removes prefixed ampersand from title' do
        entity = EntityRow.new '& Mr', 'A D', 'Man,'
        expect(entity.title).to eq 'Mr'
      end

    end

  end
end
