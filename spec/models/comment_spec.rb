require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validates' do
    it 'requires clarify' do
      expect(Comment.new(clarify: nil)).to_not be_valid
    end

    it 'allows up to max chars' do
      expect(Comment.new(clarify: 'X' * CommentDefaults::MAX_CLARIFY))
        .to be_valid
    end

    it 'rejects above max chars' do
      expect(Comment.new(clarify: 'X' * (CommentDefaults::MAX_CLARIFY + 1)))
        .to_not be_valid
    end
  end
end
