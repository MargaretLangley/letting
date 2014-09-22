require 'rails_helper'

describe Notice, type: :model do

  describe 'validations' do
    it('returns valid') { expect(notice_new).to be_valid }
    it('needs Instruction') { expect(notice_new instruction: '').to be_valid }
    it('requires fill_in') { expect(notice_new fill_in: '').to be_valid }
    it('requires sample') { expect(notice_new sample: '').to be_valid }
  end
end
