require 'spec_helper'

describe DebtGenerator do

  let(:debt_gen) { DebtGenerator.new }

  context 'validations' do
    context 'validate uniqueness' do
      it 'prevents same debt_generator being created' do
        DebtGenerator.create! debt_generator_attributes id: nil
        expect{ DebtGenerator.create! debt_generator_attributes id: nil}.to \
          raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  context 'inialization' do
    context 'empty' do
      before { Timecop.travel(Time.zone.parse('30/9/2013 12:00')) }
      after { Timecop.return }

      let(:debt_gen) { debt_gen = DebtGenerator.new }

      it 'returns today start date' do
        expect(debt_gen.start_date).to eq Date.new 2013, 9, 30
      end

      it 'returns future date' do
        expect(debt_gen.end_date).to eq Date.new 2013, 11, 25
      end
    end
    context 'with parsable strings' do
      let(:debt_gen) do
        debt_gen = DebtGenerator.new \
                    search_string: 'Lords', \
                    start_date: '2013-09-30', \
                    end_date: '2013-11-25'
      end

      it 'returns date' do
        expect(debt_gen.start_date).to eq Date.new 2013, 9, 30
      end
    end
  end

  context 'assocations' do
    it('debts') { expect(debt_gen).to respond_to(:debts)}
  end

  context 'methods' do
    context '#debtless?' do
      it 'when empty' do
        debt_gen = DebtGenerator.new
        expect(debt_gen).to be_debtless
      end
      it 'has debts when assigned' do
        debt_gen = DebtGenerator.new
        # setting up debt generation will result in complicated test
        # doing something like debt_gen.debts << Debt.new would use
        # private interface. Choose to stub present? Also ugly.
        debt_gen.debts.should_receive(:empty?).and_return(false)
        expect(debt_gen).to_not be_debtless
      end
    end
    context '#generate' do
      property = nil
      before do
       Timecop.travel(Time.zone.parse('30/2/2013 12:00'))
       property = property_with_charge_create!
      end
      after { Timecop.return }

      it 'generates' do
        gen_debts = DebtGenerator.new(search_string: 'Hillbank House').generate
        expect(gen_debts).to have(1).items
        expect(gen_debts.first).to eq \
          Debt.new on_date: '2013/3/25', amount: 88.08, \
            charge_id: property.account.charges.first.id
      end
      it 'does not duplicate debt' do
        debt_gen = DebtGenerator.new(search_string: 'Hillbank House')
        debt_gen.generate
        debt_gen.generate
        expect(debt_gen.debts).to have(1).items
      end
      it 'does not duplicate debt2' do
        debt_gen = DebtGenerator.new(search_string: 'Hillbank House')
        debt_gen.generate
        debt_gen.save!
        debt_gen = DebtGenerator.new(search_string: 'Hillbank House', start_date: Date.current+1.day)
        debt_gen.generate
        debt_gen.save!
        expect(debt_gen.debts).to have(0).items
      end
    end
  end

  it '#latest_debt_generated' do
    DebtGenerator.create debt_generator_attributes
    expect(DebtGenerator.latest_debt_generated(10).length).to eq 1
    expect(DebtGenerator.latest_debt_generated(10).first).to eq \
        DebtGenerator.new id: 1, \
                          search_string: 'Lords', \
                          start_date: '2013-03-01', \
                          end_date: '2013-04-01'
  end

end
