require 'spec_helper'

describe DebtGenerator do

  let(:debt_gen) { DebtGenerator.new }

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
    context '#debts?' do
      it 'none when unassigned' do
        debt_gen = DebtGenerator.new
        expect(debt_gen).not_to be_debts
      end
      it 'not empty when assigned' do
        debt_gen = DebtGenerator.new
        debt_gen.debts << Debt.new
        expect(debt_gen).to be_blank
      end
    end
    context '#generate' do
      before { Timecop.travel(Time.zone.parse('30/2/2013 12:00')) }
      after { Timecop.return }

      it 'generates' do
        property = property_with_charge_create!
        debt_gen = DebtGenerator.new search_string: 'Hillbank House'
        expect(debt_gen.generate).to have(1).items
        expect(debt_gen.generate.first).to eq \
        Debt.new on_date: '2013/3/25', amount: 88.08, \
           charge_id: property.account.charges.first.id
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
