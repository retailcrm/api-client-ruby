# encoding: utf-8

require 'net/http'
require 'net/https'
require 'uri'
require 'json'

# RetailCRM API Client
class Retailcrm

  def initialize(url, key)
    @rr_version = 3
    @rr_url = "#{url}/api/v#{@rr_version}/"
    @rr_key = key
    @rr_params = { :apiKey => @rr_key }
    @filter = nil
    @ids = nil
  end

  ##
  # === Get orders by filter
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders({:email => 'test@example.com', :status => 'new'}, 50, 2)
  #  => {...}
  #
  # Arguments:
  #   filter (Hash)
  #   limit (Integer) (20|50|100)
  #   page (Integer)
  def orders(filter = nil, limit = 20, page = 1)
    url = "#{@rr_url}orders"
    @rr_params[:limit] = limit
    @rr_params[:page] = page
    @filter = filter.to_a.map { |x| "filter[#{x[0]}]=#{x[1]}" }.join("&")
    make_request(url)
  end

  ##
  # === Get orders statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_statuses([26120, 19282])
  #  => {...}
  #
  # Arguments:
  #   ids (Array)
  def orders_statuses(ids = [])
    @ids = ids.map { |x| "ids[]=#{x}" }.join("&")
    url = "#{@rr_url}orders/statuses"
    make_request(url)
  end

  ##
  # ===  Get orders by id (or externalId)
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_get(345, 'id')
  #  => {...}
  #
  # Arguments:
  #   id (Integer)
  #   by (String)
  def orders_get(id, by = 'externalId')
    url = "#{@rr_url}orders/#{id}"
    if by != 'externalId'
      @rr_params[:by] = by
    end
    make_request(url)
  end

  ##
  # ===  Create order
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_create(order)
  #  => {...}
  #
  # Arguments:
  #   order (Array)
  def orders_create(order)
    url = "#{@rr_url}orders/create"
    @rr_params[:order] = order.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Edit order
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_edit(order)
  #  => {...}
  #
  # Arguments:
  #   order (Array)
  def orders_edit(order)
    id = order[:externalId]
    url = "#{@rr_url}orders/#{id}/edit"
    @rr_params[:order] = order.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Upload orders
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_upload(orders)
  #  => {...}
  #
  # Arguments:
  #   orders (Array)
  def orders_upload(orders)
    url = "#{@rr_url}orders/upload"
    @rr_params[:orders] = orders.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Set external ids for orders created into CRM
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_fix_external_ids([{:id => 200, :externalId => 334}, {:id => 201, :externalId => 364}])
  #  => {...}
  #
  # Arguments:
  #   orders (Array)
  def orders_fix_external_ids(orders)
    url = "#{@rr_url}orders/fix-external-ids"
    @rr_params[:orders] = orders.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Get orders history
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_history('2015-04-10 22:23:12', '2015-04-10 23:33:12')
  #  => {...}
  #
  # Arguments:
  #   start_date (Time) (Time.strftime('%Y-%m-%d %H:%M:%S'))
  #   end_date (Time) (Time.strftime('%Y-%m-%d %H:%M:%S'))
  #   limit (Integer) (20|50|100)
  #   offset (Integer)
  #   skip_my_changes (Boolean)
  def orders_history(start_date = nil, end_date = nil, limit = 100, offset = 0, skip_my_changes = true)
    url = "#{@rr_url}orders/history"
    @rr_params[:startDate] = start_date
    @rr_params[:endDate] = end_date
    @rr_params[:limit] = limit
    @rr_params[:offset] = offset
    @rr_params[:skipMyChanges] = skip_my_changes
    make_request(url)
  end

  ##
  # === Get customers by filter
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customers({:email => 'test@example.com'}, 50, 2)
  #  => {...}
  #
  # Arguments:
  #   filter (Hash)
  #   limit (Integer) (20|50|100)
  #   page (Integer)
  def customers(filter = nil, limit = 20, page = 1)
    url = "#{@rr_url}customers"
    @rr_params[:limit] = limit
    @rr_params[:page] = page
    @filter = filter.to_a.map { |x| "filter[#{x[0]}]=#{x[1]}" }.join("&")
    make_request(url)
  end

  ##
  # ===  Get customers by id (or externalId)
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customers_get(345, 'id')
  #  => {...}
  #
  # Arguments:
  #   id (Integer)
  #   by (String)
  def customers_get(id, by = 'externalId')
    url = "#{@rr_url}customers/#{id}"
    if by != 'externalId'
      @rr_params[:by] = by
    end
    make_request(url)
  end

  ##
  # ===  Create customer
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customer_create(customer)
  #  => {...}
  #
  # Arguments:
  #   customer (Array)
  def customers_create(customer)
    url = "#{@rr_url}customers/create"
    @rr_params[:customer] = customer.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Edit customer
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customers_edit(customer)
  #  => {...}
  #
  # Arguments:
  #   customer (Array)
  def customers_edit(customer)
    id = customer[:externalId]
    url = "#{@rr_url}customers/#{id}/edit"
    @rr_params[:customer] = customer.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Upload customers
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customers_upload(customers)
  #  => {...}
  #
  # Arguments:
  #   customers (Array)
  def customers_upload(customers)
    url = "#{@rr_url}customers/upload"
    @rr_params[:customers] = customers.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Set external ids for customers created into CRM
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.customers_fix_external_ids([{:id => 200, :externalId => 334}, {:id => 201, :externalId => 364}])
  #  => {...}
  #
  # Arguments:
  #   customers (Array)
  def customers_fix_external_ids(customers)
    url = "#{@rr_url}customers/fix-external-ids"
    @rr_params[:customers] = customers.to_json
    make_request(url, 'post')
  end

  ##
  # ===  Get delivery services
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_services
    url = "#{@rr_url}reference/delivery-services"
    make_request(url)
  end

  # Get delivery types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_types
    url = "#{@rr_url}reference/delivery-types"
    make_request(url)
  end

  ##
  # ===  Get order methods
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_methods
    url = "#{@rr_url}reference/order-methods"
    make_request(url)
  end

  ##
  # ===  Get order types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_types
    url = "#{@rr_url}reference/order-types"
    make_request(url)
  end

  # Get payment statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_statuses
    url = "#{@rr_url}reference/payment-statuses"
    make_request(url)
  end

  ##
  # ===  Get payment types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_types
    url = "#{@rr_url}reference/payment-types"
    make_request(url)
  end

  ##
  # ===  Get product statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def product_statuses
    url = "#{@rr_url}reference/product-statuses"
    make_request(url)
  end

  # Get sites list
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def sites
    url = "#{@rr_url}reference/sites"
    make_request(url)
  end

  ##
  # ===  Get status groups
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def status_groups
    url = "#{@rr_url}reference/status-groups"
    make_request(url)
  end

  # Get statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statuses
    url = "#{@rr_url}reference/statuses"
    make_request(url)
  end

  ##
  # ===  Get stores
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def stores
    url = "#{@rr_url}reference/stores"
    make_request(url)
  end


  ##
  # ===  Statistic update
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statistic_update
    url = "#{@rr_url}statistic/update"
    make_request(url)
  end

  protected

  def make_request(url, method='get')
    raise ArgumentError, 'url must be not empty' unless !url.empty?
    uri = URI.parse(url)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    if method == 'post'
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(@rr_params)
    elsif method == 'get'
      request = Net::HTTP::Get.new(uri.path)
      request.set_form_data(@rr_params)

      if @filter.nil?
        data = "#{request.body}"
      else
        data = "#{request.body}&#{@filter}"
      end

      if @ids.nil?
        data = "#{request.body}"
      else
        data = "#{request.body}&#{@ids}"
      end

      request = Net::HTTP::Get.new("#{uri.path}?#{data}")
    end
    response = https.request(request)
    Retailcrm::Response.new(response.code, response.body)
  end
end

class Retailcrm::Response
    attr_reader :status, :response

    def initialize(status, body)
        @status = status
        @response = body.empty? ? [] : JSON.parse(body)
    end

    def is_successfull?
        @status.to_i < 400
    end
end
