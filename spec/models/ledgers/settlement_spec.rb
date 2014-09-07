require 'rails_helper'

describe Settlement, :ledgers, type: :model do
  describe 'resolve' do
    describe 'matched settlement' do
      it 'completes when settlement == offset' do
        offset = credit_create amount: -3.00
        expect { |b| Settlement.resolve(3.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)
      end

      it 'completes when settlement == summed offsets' do
        offsets = [credit_create(amount: -4.00), credit_create(amount: -2.00)]
        expect { |b| Settlement.resolve(6.00, offsets, &b) }
          .to yield_successive_args([offsets[0], 4.00], [offsets[1], 2.00])
      end

      it 'handles debit being the offset' do
        offset = Debit.create! debit_attributes amount: 3.00
        expect { |b| Settlement.resolve(3.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)

      end

      it 'handles summed debits being the offset' do
        offsets = [Debit.create!(debit_attributes on_date: '25/3/2013',
                                                  amount: 3.00),
                   Debit.create!(debit_attributes amount: 3.00,
                                                  on_date: '25/3/2014')
                  ]
        expect { |b| Settlement.resolve(6.00, offsets, &b) }
          .to yield_successive_args([offsets[0], 3.00], [offsets[1], 3.00])
      end
    end

    describe 'maximum settlement' do
      it 'returns a settlement no more than settle ' do
        offset = credit_create amount: -5.00
        expect { |b| Settlement.resolve(4.00, [offset], &b) }
          .to yield_with_args(offset, 4.00)
      end

      it 'returns a settlement no more than offset(s)' do
        offset = credit_create amount: -3.00
        expect { |b| Settlement.resolve(4.00, [offset], &b) }
          .to yield_with_args(offset, 3.00)
      end
    end
  end
end
