# encoding: utf-8

require 'minitest/autorun'
require_relative '../lib/retailcrm'
require_relative './bootstrap'

class RetailcrmTest < Minitest::Test
  def setup
    @boot = Bootstrap.new
    @api  = Retailcrm.new(@boot.api_url, @boot.api_key)
  end

  def test_delivery_services
    assert_equal true,
      @api.delivery_services.is_successfull?
  end

  def test_delivery_types
    assert_equal true,
      @api.delivery_types.is_successfull?
  end

  def test_order_methods
    assert_equal true,
      @api.order_methods.is_successfull?
  end
end
