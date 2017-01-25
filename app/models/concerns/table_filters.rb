module TableFilters
  extend ActiveSupport::Concern
  included do
    scope :table_filters, lambda { |params, default_order|
      query = if params[:column] && params[:sort]
                order("#{params[:column]} #{params[:sort]}")
              else
                params[:column] = default_order.split.first
                params[:sort] = default_order.split.second
                order(default_order)
              end
      query = query.quick_search(params[:q]) if params[:q]
      return query
    }
  end

  module ClassMethods
    def columns_filtered(*columns)
      clause = columns.map { |c| "lower(#{c}) like :wildcard_kb" }.join ' OR '
      scope :quick_search, lambda { |keyword|
        where clause,
              wildcard_kb: "%#{keyword.to_s.downcase}%"
      }
    end
  end
end
