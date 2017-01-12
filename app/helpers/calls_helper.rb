module CallsHelper
  # rubocop:disable MethodLength
  def sort_column_by(title, column)
    # initialize values
    sort = :desc
    icon_class = 'sort'

    # sort order
    if params[:column] == column.to_s
      sort = params[:sort] == 'asc' ? :desc : :asc
      icon_class = "sort-#{sort}"
    end

    # header with link
    link_to calls_path(request.query_parameters
                           .merge(column: column, sort: sort)),
            class: 'sort-link', title: sort do
      icon icon_class, title
    end
  end
end
