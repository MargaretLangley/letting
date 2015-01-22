
####
#
# LinkHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/MethodLength,  Metrics/ParameterLists
#
####
#
module LinkHelper
  def view_link model, icon: 'file-o', css: '', title: 'View file'
    if model.new_record?
      app_link icon: icon, size: '2x', disabled: true, css: css, title: title
    else
      app_link icon: icon, size: '2x', path: model, css: css, title: title
    end
  end

  def edit_link model, size: '2x', css: '', title: 'Edit File'
    app_link icon: 'edit',
             size: size,
             path: [:edit, model],
             css: css,
             title: title
  end

  def edit_index_link model, size: 'lg'
    app_link icon: 'edit', size: size, path: [:edit, model], title: 'Edit file'
  end

  def add_link(size: 'lg', css:, title:)
    app_link icon: 'plus-circle', size: size, css: "#{css}", title: title
  end

  def delete_link path: '#',
                  confirm: 'Are you sure you want to delete?',
                  title: 'Delete File'
    app_link icon: 'trash-o',
             path: path,
             method: :delete,
             data: { confirm: confirm },
             title: title
  end

  def delete_charge(css:)
    app_link icon: 'trash-o', css: "#{css}", title: 'Delete charge'
  end

  # passing model object did not work.
  #
  def payment_link(size: 'lg', path:)
    app_link icon: 'gbp', size: size, path: path, title: 'Add New Payment'
  end

  def print_link model, title: 'Print'
    app_link icon: 'print', path: print_run_path(model), title: title
  end

  def toggle_link direction:, size: 'lg', title: ''
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             css: "js-toggle  #{hover direction: direction } ",
             title: title
  end

  #
  # None Standard links that we haven't called app_link on
  #

  def cancel_link(path:)
    link_to 'Cancel', path, class: 'warn'
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
               data: nil,
               method: nil,
               title:,
               disabled: false)

    link_to fa_icon("#{icon} #{size}"),
            path,
            class: "plain-button  hvr-grow  #{css}",
            title: "#{title}#{disabled ? ' (disabled)' : '' }",
            data: data,
            method: method,
            disabled: disabled
  end

  def hover(direction:)
    direction == :down ? 'hvr-sink' : 'hvr-float'
  end
end
