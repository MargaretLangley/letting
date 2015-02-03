
####
#
# LinkHelper
#
# Shared helper methods
#
# rubocop: disable Metrics/LineLength, Metrics/MethodLength,  Metrics/ParameterLists
#
####
#
module LinkHelper
  def view_link model
    if model.new_record?
      app_link icon: 'file-o', size: '2x', disabled: true, title: 'View file'
    else
      app_link icon: 'file-o', size: '2x', path: model, title: 'View file'
    end
  end

  def edit_link model, size: '2x', title: title
    app_link icon: 'edit',
             size: size,
             path: [:edit, model],
             title: "Edit #{model.class.name}"
  end

  def add_link(icon: 'plus-circle', size: 'lg', path: '#', css: '', js_css: '', title:)
    app_link icon: icon, size: size, path: path, css: css, js_css: js_css, title: title
  end

  def delete_charge js_css:, title: 'Delete Charge'
    delete_link method: nil, js_css: js_css, data: false, title: title
  end

  def delete_link path: '#',
                  js_css: '',
                  method: :delete,
                  data: true,
                  confirm: 'Are you sure you want to delete?',
                  title: 'Delete File',
                  disabled: false
    app_link icon: 'trash-o',
             path: path,
             method: method,
             js_css: js_css,
             data: data ? { confirm: confirm } : nil,
             title: title,
             disabled: disabled
  end

  # passing model object did not work.
  #
  def payment_link(path:)
    app_link icon: 'gbp', path: path, title: 'Add New Payment'
  end

  def print_link path:, title: 'Print'
    app_link icon: 'print', path: path, title: title
  end

  def toggle_link direction:, size: 'lg', title: ''
    app_link icon: "chevron-circle-#{direction}",
             size: size,
             js_css: "js-toggle  #{hover direction: direction } ",
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
               text: '',
               path: '#',
               css: 'plain-button',
               js_css: '',
               data: nil,
               method: nil,
               title:,
               disabled: false)
    if disabled == false
      link_to fa_icon("#{icon} #{size}", text: text),
              path,
              class: "#{hover_grow(disabled: disabled)}  #{css}  #{js_css}",
              title: title,
              method: method,
              data: data,
              disabled: disabled
    else
      # A solution that gives the wrong size - the content_tag
      # is added to allow for no-print
      # content_tag :div, class: "no-print" do
      #   fa_icon("#{icon} 2x",
      #        text: text,
      #        class: 'plain-button',
      #        disabled: true,
      #        title: "#{title} (disabled)")
      # end

      # This is a solution which is most similar to the golden path
      # EXCEPT the part of the icon above 1 line height does not get
      # a background
      link_to fa_icon("#{icon} #{size}", text: text),
              '#',
              class: 'plain-button',
              disabled: true,
              title: "#{title} (disabled)"
    end

  end

  def hover_grow(disabled:)
    return '' if disabled
    'hvr-grow'
  end

  def hover(direction:)
    direction == :down ? 'hvr-sink' : 'hvr-float'
  end
end
