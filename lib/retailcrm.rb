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
  end

  ##
  # === Get orders by filter
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders(50, 2, {:email => 'test@example.com', :status => 'new'})
  #  => {...}
  #
  # Arguments:
  #   limit (Integer) (20|50|100)
  #   page (Integer)
  #   filter (Array)
  def orders(filter = {}, limit = 20, page = 1)
    url = "#{@rr_url}orders"
    @rr_params[:limit] = limit
    @rr_params[:page] = page
    @rr_params[:filter] = filter.to_json
    return make_request(url)
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
    if (by != 'externalId')
      @rr_params[:by] = by
    end
    return make_request(url)
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
    return make_request(url, 'post')
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
    return make_request(url, 'post')
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
    result = JSON.parse(make_request(url, 'post'))
    return result[:uploadedOrders] || result
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
    return make_request(url, 'post')
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
  #   startDate (Time) (Time.strftime('%Y-%m-%d %H:%M:%S'))
  #   endDate (Time) (Time.strftime('%Y-%m-%d %H:%M:%S'))
  #   limit (Integer) (20|50|100)
  #   offset (Integer)
  def orders_history(startDate = nil, endDate = nil, limit = 20, offset = 0)
    url = "#{@rr_url}orders/history"
    @rr_params[:startDate] = startDate
    @rr_params[:endDate] = endDate
    @rr_params[:limit] = limit
    @rr_params[:offset] = offset
    return make_request(url)
  end

  ##
  # ===  Get orders statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  # Example:
  #  >> Retailcrm.orders_statuses([231,244,356,564])
  #  => {...}
  #
  # Arguments:
  #   ids (Array)
  def orders_statuses(ids)
    url = "#{@rr_url}orders/statuses/#{ids}"
    return make_request(url)
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
    if (by != 'externalId')
      @rr_params[:by] = by
    end
    return make_request(url)
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
    return make_request(url, 'post')
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
  def customers_edit(customer, id)
    url = "#{@rr_url}customers/#{id}/edit"
    @rr_params[:customer] = customer.to_json
    return make_request(url, 'post')
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
    result = JSON.parse(make_request(url, 'post'))
    return result[:uploaded] || result
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
    return make_request(url, 'post')
  end

  ##
  # ===  Get delivery services
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_services
    url = "#{@rr_url}reference/delivery-services"
    return make_request(url)
  end

  # Get delivery types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def delivery_types
    url = "#{@rr_url}reference/delivery-types"
    return make_request(url)
  end

  ##
  # ===  Get order methods
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_methods
    url = "#{@rr_url}reference/order-methods"
    return make_request(url)
  end

  ##
  # ===  Get order types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def order_types
    url = "#{@rr_url}reference/order-types"
    return make_request(url)
  end

  # Get payment statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_statuses
    url = "#{@rr_url}reference/payment-statuses"
    return make_request(url)
  end

  ##
  # ===  Get payment types
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def payment_types
    url = "#{@rr_url}reference/payment-types"
    return make_request(url)
  end

  ##
  # ===  Get product statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def product_statuses
    url = "#{@rr_url}reference/product-statuses"
    return make_request(url)
  end

  # Get sites list
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def sites
    url = "#{@rr_url}reference/sites"
    return make_request(url)
  end

  ##
  # ===  Get status groups
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def status_groups
    url = "#{@rr_url}reference/status-groups"
    return make_request(url)
  end

  # Get statuses
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statuses
    url = "#{@rr_url}reference/statuses"
    return make_request(url)
  end

  ##
  # ===  Get stores
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def stores
    url = "#{@rr_url}reference/stores"
    return make_request(url)
  end


  ##
  # ===  Statistic update
  # http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3
  #
  def statistic_update
    url = "#{@rr_url}statistic/update"
    return make_request(url)
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
      request = Net::HTTP::Get.new("#{uri.path}?#{request.body}")
    end
    response = https.request(request)
    return Retailcrm::Response.new(response.code, response.body)
  end
end

class Retailcrm::Response
    def initialize(status, body)
        @status = status
        @response = body.empty? ? [] : JSON.parse(body);
    end
    
    def get_status
        return @status
    end
    
    def get_response
        return @response
    end
    
    def is_successfull?
        return @status.to_i < 400
    end
end
