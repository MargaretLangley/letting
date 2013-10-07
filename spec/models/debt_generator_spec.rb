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

    context 'Properties' do
      it 'invalid without properties' do
        debt_gen.properties = []
        expect(debt_gen).to_not be_valid
      end

      it 'requires properties to be valid' do
        debt_gen.should_receive(:properties).and_return([Object.new])
        expect(debt_gen).to be_valid
      end
    end
    context 'dates' do

      it 'start date required' do
        debt_gen.start_date = nil
        expect(debt_gen).to_not be_valid
      end

      it 'end date required' do
        debt_gen.end_date = nil
        expect(debt_gen).to_not be_valid
      end

      it 'start date > end date' do
        debt_gen.end_date = Date.new 2013, 2, 1
        expect(debt_gen).to_not be_valid
      end
    end
  end

  context 'assocations' do
    it('debts') { expect(debt_gen).to respond_to(:debts) }
  end

  context 'default inialization' do
    let(:debt_gen) { DebtGenerator.new }
    before { Timecop.travel(Date.new(2013, 9, 30)) }
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
        Timecop.travel(Date.new(2013, 1, 31))
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
        debt_gen = DebtGenerator.new(search_string: 'Hillbank House')
        debt_gen.generate
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
        debt_gen.should_receive(:debts).and_return([Object.new])
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
    debt_gen = DebtGenerator.new debt_generator_attributes \
                                 properties: [Object.new]
    debt_gen.debts.build debt_attributes
    debt_gen
  end
end
