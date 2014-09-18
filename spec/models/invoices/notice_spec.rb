# rubocop: disable Metrics/LineLength
require 'rails_helper'

describe Notice, type: :model do

  describe 'validations' do
    it('returns valid') { expect(notice_new).to be_valid }
    it('accepts a blank instruction') { expect(notice_new instruction: '').to be_valid }
    it('accepts a blank clause') { expect(notice_new clause: '').to be_valid }
    it('accepts a blank proxy') { expect(notice_new proxy: '').to be_valid }
  end
end
