require 'spec_helper'

describe NavigationHelper, type: :helper do
  describe '#active_nav?' do
    it 'returns "active" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(active_nav? 'accounts').to include 'active-nav'
    end
    it 'returns "inactive" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(active_nav? 'accounts').to include 'inactive-nav'
    end
  end

  describe '#revealable?' do
    it 'returns "visible" when "selection" is on named controller' do
      allow(controller).to receive(:controller_name).and_return('accounts')
      expect(revealable? 'accounts').to include 'visible'
    end
    it 'returns "revealable" when "selection" is on different controller' do
      allow(controller).to receive(:controller_name).and_return('mismatch')
      expect(revealable? 'accounts').to include 'revealable'
    end
  end
end
