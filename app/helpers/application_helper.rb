require_relative '../../lib/modules/salient_date'

####
#
# ApplicationHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/MethodLength,  Metrics/ParameterLists
#
####
#
module ApplicationHelper
  include SalientDate
  def format_empty_string_as_dash a_string
    a_string.blank? ? '-'  : a_string
  end

  def payment_types
    Charge::PAYMENT_TYPE.map { |type| [type.humanize, type] }
  end

  def view_link model, size: '2x'
    if model.new_record?
      app_link icon: 'file-o', size: size, disabled: true, title: 'View file'
    else
      app_link icon: 'file-o', size: size, path: model, title: 'View file'
    end
  end

  def edit_link model, size: 'lg'
    app_link icon: 'edit', size: size, path: [:edit, model], title: 'Edit file'
  end

  def add_link(size: 'lg', css:, title:)
    app_link icon: 'plus-circle', size: size, css: css, title: title
  end

  def delete_link(path: '#', css: 'float-right', title: 'Delete File')
    link_to fa_icon('trash-o lg'),
            path,
            method: :delete,
            class: "plain-button  #{css}",
            data: { confirm: 'Are you sure you want to delete?' },
            title: title
  end

  def delete_charge(record:)
    app_link icon: 'trash-o',
             css: "float-right #{hide_or_destroy record: record}",
             title: 'Delete charge'
  end

  def cancel_link(path:)
    link_to 'Cancel', path, class: 'warn'
  end

  # payment should be nested in accounts but is not
  # we have to force the path rather than pass in parent object
  #
  def payment_link path:, size: 'lg'
    app_link icon: 'gbp', size: size, path: path, title: 'Add New Payment'
  end

  def print_link model, title: 'Print', css: 'float-right'
    app_link icon: 'print', path: print_path(model), css: css, title: title
  end

  def toggle_link direction:, size: 'lg'
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             css: 'js-toggle  float-right',
             title: 'Full Property'
  end

  # Used when there is no physical link to click on
  # In the case of index - grid row has no view button.
  #
  def testing_link(path:)
    link_to '', path, class: 'view-testing-link'
  end

  private

  def app_link(icon:,
               size: 'lg',
               path: '#',
               css: 'float-right',
               title:,
               disabled: false)
    link_to fa_icon("#{icon} #{size}"),
            path,
            class: "plain-button  #{css}",
            title: "#{title}#{disabled ? ' (disabled)' : '' }",
            disabled: disabled
  end
end
