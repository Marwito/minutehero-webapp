module ApplicationHelper
  # rubocop:disable MethodLength, AbcSize
  def sort_column_by(column, title = '')
    # initialize values
    sort = :desc
    icon_class = 'sort'
    column_title = (title.blank?)?
        ActiveSupport::Inflector.titleize(column) :
        title

    # sort order
    if params[:column] == column.to_s
      sort = params[:sort] == 'asc' ? :desc : :asc
      icon_class = "sort-#{sort}"
    end

    # header with link
    link_to Rails.application.routes.url_helpers.send(
      :"#{request.path[1..-1]}_path",
        request.query_parameters.merge(column: column, sort: sort)
    ),
            class: 'sort-link', title: sort do
      icon icon_class, column_title
    end
  end
end
