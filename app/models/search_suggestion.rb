class SearchSuggestion < ActiveRecord::Base
  def self.terms_for prefix
    suggestions = where('term ilike ?', "#{prefix}_%")
    suggestions.order('popularity desc').limit(10).pluck(:term)
  end

  def self.index_properties
    Property.find_each do |property|
      index_term(property.address.house_name)
      index_term(property.address.road)
      index_term(property.address.town)
    end
  end

  def self.index_term term
    where(term: term).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end
end
