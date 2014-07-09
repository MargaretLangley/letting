require 'spec_helper'

describe DebitGenerator do

  let(:debit_gen) { debit_generator_new }

  it 'is valid when created by the factory' do
    expect(debit_gen).to be_valid
  end

  describe 'validations' do

    it 'invalid with no debits' do
      debit_gen.debits = []
      expect(debit_gen).to_not be_valid
    end

    it 'only allows debit_generator to create unique debits' do
      debit_generator_new.save!
      expect { debit_generator_new.save! }
        .to raise_error ActiveRecord::RecordInvalid
    end

    describe 'Properties' do
      it 'invalid without accounts' do
        debit_gen.accounts = []
        expect(debit_gen).to_not be_valid
      end

      it 'are required to be valid' do
        debit_gen.should_receive(:accounts).and_return([Object.new])
        expect(debit_gen).to be_valid
      end
    end

    describe 'dates' do
      it 'requires a start date' do
        debit_gen.start_date = nil
        expect(debit_gen).to_not be_valid
      end

      it 'requires an end date' do
        debit_gen.end_date = nil
        expect(debit_gen).to_not be_valid
      end

      it 'requires the start date < end date' do
        debit_gen.start_date = Date.new 2013, 2, 1
        debit_gen.end_date = Date.new 2013, 1, 31
        expect(debit_gen).to_not be_valid
      end
    end
  end

  context 'New DebitGenerator' do
    let(:debit_gen) { DebitGenerator.new }
    before { Timecop.travel(Date.new(2013, 9, 30)) }
    after { Timecop.return }

    it 'has a start date' do
      expect(debit_gen.start_date).to eq Date.new 2013, 9, 30
    end

    it 'has an end date' do
      expect(debit_gen.end_date).to eq Date.new 2013, 11, 25
    end
  end

  describe 'methods' do
    describe '#generate' do
      property = nil
      before do
        Timecop.travel(Date.new(2013, 1, 31))
        property = property_with_charge_create!
        Property.import force: true, refresh: true
      end
      after do
        Property.__elasticsearch__.delete_index!
        Timecop.return
      end

      it 'creates debits' do
        (generator = DebitGenerator.new(search_string: 'Hillbank House')).generate
        generated_debits = generator.debits.select(&:new_record?)
        expect(generated_debits).to have(1).items
        expect(generated_debits.first)
          .to eq Debit.new on_date: '2013/3/25',
                           amount: 88.08,
                           charge_id: property.account.charges.first.id
      end

      it 'only makes unique debits' do
        debit_gen = DebitGenerator.new(search_string: 'Hillbank House')
        debit_gen.generate
        debit_gen.save!
        debit_gen = DebitGenerator.new(search_string: 'Hillbank House',
                                       start_date: Date.current + 1.day)
        debit_gen.generate
        expect { debit_gen.save! }.to raise_error
      end
    end

    describe '#debitless?' do
      it('when empty') { expect(DebitGenerator.new).to be_debitless }
      it 'indebited when debits assigned' do
        debit_gen = DebitGenerator.new
        debit_gen.should_receive(:debits).and_return([Object.new])
        expect(debit_gen).to_not be_debitless
      end
    end

    it '#latest_debit_generated' do
      debit_generator_new.save!
      expect(DebitGenerator.latest_debit_generated(10).length).to eq 1
      expect(DebitGenerator.latest_debit_generated(10).first)
        .to eq DebitGenerator.new id: 1,
                                  search_string: 'Lords',
                                  start_date: '2013-03-01',
                                  end_date: '2013-04-01'
    end
  end

  def debit_generator_new
    debit_gen = DebitGenerator.new debit_generator_attributes \
                                 accounts: [Object.new]
    debit_gen.debits.build debit_attributes
    debit_gen
  end
end
