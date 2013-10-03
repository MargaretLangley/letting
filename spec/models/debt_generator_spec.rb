require 'spec_helper'

describe DebtGenerator do

  let(:debt_gen) { debt_generator_new }

  context 'validations' do
    it 'basic is valid' do
      expect(debt_gen).to be_valid
    end
    it 'invalid with no debts' do
      debt_gen.debts = []
      expect(debt_gen).to_not be_valid
    end
    context 'validate uniqueness' do
      it 'prevents debt_generator with same attributes from being created' do
        debt_generator_new.save!
        expect { debt_generator_new.save! }.to  \
          raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context 'assocations' do
    it('debts') { expect(debt_gen).to respond_to(:debts) }
  end

  context 'default inialization' do
    let(:debt_gen) { DebtGenerator.new }
    before { Timecop.travel(Time.zone.parse('30/9/2013 12:00')) }
    after { Timecop.return }

    it 'has start date' do
      expect(debt_gen.start_date).to eq Date.new 2013, 9, 30
    end

    it 'has end date' do
      expect(debt_gen.end_date).to eq Date.new 2013, 11, 25
    end
  end

  context 'methods' do

    context '#generate' do
      property = nil
      before do
        Timecop.travel(Time.zone.parse('30/2/2013 12:00'))
        property = property_with_charge_create!
      end
      after { Timecop.return }

      it 'generates debts' do
        new_debts = DebtGenerator.new(search_string: 'Hillbank House').generate
        expect(new_debts).to have(1).items
        expect(new_debts.first).to eq \
          Debt.new on_date: '2013/3/25',
                   amount: 88.08,
                   charge_id: property.account.charges.first.id
      end

      it 'does not duplicate debt' do
        (debt_gen = DebtGenerator.new(search_string: 'Hillbank House')).generate
        debt_gen.save!
        debt_gen = DebtGenerator.new(search_string: 'Hillbank House',
                                     start_date: Date.current + 1.day)
        debt_gen.generate
        expect { debt_gen.save! }.to raise_error
      end
    end

    context '#debtless?' do
      it('when empty') { expect(DebtGenerator.new).to be_debtless }
      it 'indebted when debts assigned' do
        debt_gen = DebtGenerator.new
        # setting up debt generation will result in complicated test
        # doing something like debt_gen.debts << Debt.new would use
        # private interface. Choose to stub present? Also ugly.
        debt_gen.debts.should_receive(:empty?).and_return(false)
        expect(debt_gen).to_not be_debtless
      end
    end

    it '#latest_debt_generated' do
      debt_generator_new.save!
      expect(DebtGenerator.latest_debt_generated(10).length).to eq 1
      expect(DebtGenerator.latest_debt_generated(10).first).to eq \
          DebtGenerator.new id: 1,
                            search_string: 'Lords',
                            start_date: '2013-03-01',
                            end_date: '2013-04-01'
    end
  end

  def debt_generator_new
    debt_gen = DebtGenerator.new debt_generator_attributes
    debt_gen.debts.build debt_attributes
    debt_gen
  end
end
