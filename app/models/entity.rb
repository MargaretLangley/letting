####
#
# Entity
#
# Why does this class exist?
#
# represents a person or company in the application.
#
# How does this fit into the larger system
#
# Entity are used in Properties, clients, and billing profile / agents.
# The name and addresses were paired together in the contactable module
# in all the above cases.
#
#
# The polymorphic relationship, entitieable, allowing a model to associate
# with more than one other model type (client, Property and BillingProfile).
#
# The module was introduced for code reuse (having a has_a contact would
# have been worth investigating).
#
####
#
class Entity < ActiveRecord::Base
  belongs_to :entitieable, polymorphic: true
  validates :entity_type, presence: true
  validates :name, length: { maximum: 64 }, presence: true
  validates :title, :initials, length: { maximum: 10 }

  def prepare
    self.entity_type = 'Person' if new_record?
  end

  def all?
    true
  end

  def empty?
    attributes.except(*ignored_attrs).values.all?(&:blank?)
  end

  def company?
    entity_type == 'Company'
  end

  def full_name
    "#{title} #{initials} #{name}".strip
  end

  private

    def ignored_attrs
      %w[id entitieable_id entitieable_type created_at entity_type updated_at]
    end
end
