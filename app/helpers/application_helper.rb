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

  def view_link model, size: '2x', css: 'float-right  hvr-grow'
    if model.new_record?
      app_link icon: 'file-o',
               size: size,
               disabled: true,
               css: css,
               title: 'View file'
    else
      app_link icon: 'file-o',
               size: size,
               path: model,
               css: css,
               title: 'View file'
    end
  end

  def edit_link model, size: '2x', css: 'float-right'
    app_link icon: 'edit',
             size: size,
             path: [:edit, model],
             css: css,
             title: 'Edit file'
  end

  def edit_index_link model, size: 'lg'
    app_link icon: 'edit', size: size, path: [:edit, model], title: 'Edit file'
  end

  def add_link(size: 'lg', css:, title:)
    app_link icon: 'plus-circle', size: size, css: "#{css}", title: title
  end

  def delete_link(path: '#',
                  title: 'Delete File',
                  confirm: 'Are you sure you want to delete?')
    link_to fa_icon('trash-o lg'),
            path,
            method: :delete,
            class: 'plain-button  hvr-grow',
            data: { confirm: confirm },
            title: title
  end

  def delete_charge(record:)
    app_link icon: 'trash-o',
             css: "float-right  hvr-grow  #{hide_or_destroy record: record}",
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
    app_link icon: 'print', path: print_run_path(model), css: css, title: title
  end

  def toggle_link direction:, size: 'lg', title: ''
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             css: "js-toggle  float-right #{hover direction: direction } ",
             title: title
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
               css: '',
               title:,
               disabled: false)

    link_to fa_icon("#{icon} #{size}"),
            path,
            class: "plain-button  hvr-grow  #{css}",
            title: "#{title}#{disabled ? ' (disabled)' : '' }",
            disabled: disabled
  end

  def hover(direction:)
    direction == :down ? 'hvr-sink' : 'hvr-float'
  end
end
