require_relative '../../lib/modules/salient_date'

####
#
# ApplicationHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/MethodLength
#
####
#
module ApplicationHelper
  include SalientDate
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def edit_link model
    link_to fa_icon('edit lg'),
            [:edit, model],
            class: 'plain-button float-right',
            title: 'Edit file'
  end

  def delete_link model
    link_to fa_icon('trash-o lg'),
            model,
            method: :delete,
            class: 'plain-button float-right',
            data: { confirm: 'Are you sure you want to delete?' },
            title: 'Delete file'
  end

  def view_link model
    if model.new_record?
      link_to fa_icon('file-o lg'),
              '#',
              class: 'plain-button float-right',
              disabled: true, title: 'View file (disabled)'
    else
      link_to fa_icon('file-o lg'),
              model,
              class: 'plain-button float-right',
              title: 'View file'
    end
  end

  def print_link(model, title: 'Print', css: 'plain-button float-right')
    link_to fa_icon('print lg'),
            print_path(model),
            title: title,
            class: css
  end

  def chevron_link(direction:)
    link_to fa_icon("chevron-circle-#{direction} lg"),
            '#',
            class: 'js-toggle  plain-button float-right',
            title: 'Full Property'
  end
end
