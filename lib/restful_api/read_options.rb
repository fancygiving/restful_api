module RestfulApi
  class ReadOptions
    attr_reader :options, :page, :per_page, :order

    def initialize(options={})
      @options = options
      @page = options[:page]
      @per_page = options[:per_page]
      @order = options[:order]
    end

    def ordering
      offset_and_limit + [order]
    end

    def datamapper_options
      {}.merge(datamapper_order).merge(offset_and_limit_options)
    end

    def datamapper_order
      return {} unless order.present?
      { order: [order_field.to_sym.send(order_direction)] }
    end

    def offset_and_limit_options
      return {} unless offset.present? and limit.present?
      { offset: offset, limit: limit }
    end

    def order_field
      order_direction_and_field[1]
    end

    def order_direction
      order_direction_and_field[0]
    end

    def order_direction_and_field
      order.to_s.reverse.split('_', 2).map(&:reverse)
    end

    def offset
      if page && per_page
        page.to_i * per_page.to_i
      end
    end

    def limit
      if page && per_page
        per_page.to_i
      end
    end

    def offset_and_limit
      [offset, limit]
    end
  end
end