# encoding: utf-8

require 'net/http'
require 'net/https'
require 'uri'
require 'json'

# RetailCRM API Client
class Retailcrm

  def initialize(url, key)
    @version = 3
    @url = "#{url}/api/v#{@version}/"
    @key = key
    @params = { :apiKey => @key }
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
    url = "#{@url}orders"
    @params[:limit] = limit
    @params[:page] = page
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
    url = "#{@url}orders/statuses"
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
    url = "#{@url}orders/#{id}"
    if by != 'externalId'
      @params[:by] = by
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
    url = "#{@url}orders/create"
    @params[:order] = order.to_json
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
    url = "#{@url}orders/#{id}/edit"
    @params[:order] = order.to_json
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
    url = "#{@url}orders/upload"
    @params[:orders] = orders.to_json
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
    url = "#{@url}orders/fix-external-ids"
    @params[:orders] = orders.to_json
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
    url = "#{@url}orders/history"
    @params[:startDate] = start_date
    @params[:endDate] = end_date
    @params[:limit] = limit
    @params[:offset] = offset
    @params[:skipMyChanges] = skip_my_changes
    make_request(url)
  end

  ##
  # === Get orders assembly history
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_packs_history({:orderId => 26120, :startDate => '2015-04-10 23:33:12'}, 50, 2)
  #  => {...}
  #
  # Arguments:
  #   filter (Hash)
  #   limit (Integer) (20|50|100)
  #   page (Integer)
  def orders_packs_history(filter = nil, limit = 20, page = 1)
    url = "#{@url}orders/packs/history"
    @params[:limit] = limit
    @params[:page] = page
    @filter = filter.to_a.map { |x| "filter[#{x[0]}]=#{x[1]}" }.join("&")
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
    url = "#{@url}customers"
    @params[:limit] = limit
    @params[:page] = page
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
    url = "#{@url}customers/#{id}"
    if by != 'externalId'
      @params[:by] = by
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
    url = "#{@url}customers/create"
    @params[:customer] = customer.to_json
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
    url = "#{@url}customers/#{id}/edit"
    @params[:customer] = customer.to_json
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
    url = "#{@url}customers/upload"
    @params[:customers] = customers.to_json
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
    url = "#{@url}customers/fix-external-ids"
    @params[:customers] = customers.to_json
    make_request(url, 'post')
  end

  ##
  # === Get purchace prices & stock balance
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.store_inventories({:productExternalId => 26120, :details => 1}, 50, 2)
  #  => {...}
  #
  # Arguments:
  #   filter (Hash)
  #   limit (Integer) (20|50|100)
  #   page (Integer)
  def store_inventories(filter = nil, limit = 20, page = 1)
    url = "#{@url}store/inventories"
    @params[:limit] = limit
    @params[:page] = page
    @filter = filter.to_a.map { |x| "filter[#{x[0]}]=#{x[1]}" }.join("&")
    make_request(url)
  end

  ##
  # ===  Get delivery services
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_services
    url = "#{@url}reference/delivery-services"
    make_request(url)
  end

  # Get delivery types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_types
    url = "#{@url}reference/delivery-types"
    make_request(url)
  end

  ##
  # ===  Get order methods
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_methods
    url = "#{@url}reference/order-methods"
    make_request(url)
  end

  ##
  # ===  Get order types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_types
    url = "#{@url}reference/order-types"
    make_request(url)
  end

  # Get payment statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_statuses
    url = "#{@url}reference/payment-statuses"
    make_request(url)
  end

  ##
  # ===  Get payment types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_types
    url = "#{@url}reference/payment-types"
    make_request(url)
  end

  ##
  # ===  Get product statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def product_statuses
    url = "#{@url}reference/product-statuses"
    make_request(url)
  end

  # Get sites list
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def sites
    url = "#{@url}reference/sites"
    make_request(url)
  end

  ##
  # ===  Get status groups
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def status_groups
    url = "#{@url}reference/status-groups"
    make_request(url)
  end

  # Get statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statuses
    url = "#{@url}reference/statuses"
    make_request(url)
  end

  ##
  # ===  Get stores
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def stores
    url = "#{@url}reference/stores"
    make_request(url)
  end


  ##
  # ===  Statistic update
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statistic_update
    url = "#{@url}statistic/update"
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
      request.set_form_data(@params)
    elsif method == 'get'
      request = Net::HTTP::Get.new(uri.path)
      request.set_form_data(@params)

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
