# ActAsFakeDeletable
#
# Pretend to delete data - instead flag row up and
# add scope to filter rows out.
#
#
module ActAsFakeDeletable
  extend ActiveSupport::Concern
  included do
    # override the model actions
    def delete
      update_attributes(deleted_at: DateTime.current)
    end

    def destroy
      update_attributes(deleted_at: DateTime.current)
    end

    # define new scopes
    def self.included(base)
      base.class_eval do
        scope :deleted, -> { where('deleted_at IS NOT NULL') }
        scope :not_deleted, -> { where('deleted_at IS NULL') }

        scope :destroyed, -> { where('deleted_at IS NOT NULL') }
        scope :not_destroyed, -> { where('deleted_at IS NULL') }
      end
    end
  end
end
