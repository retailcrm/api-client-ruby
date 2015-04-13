# encoding: utf-8

require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/retailcrm'
require_relative './bootstrap'

describe Retailcrm do
  before do
    @boot = Bootstrap.new
    @api  = Retailcrm.new(@boot.api_url, @boot.api_key)
  end

  describe '#delivery services status code' do
    it 'checks successful status code of delivery services' do
      @api.delivery_services.status.to_i.must_be :<, 400
    end
  end
  
  describe '#delivery types status code' do
    it 'checks successful status code of delivery types' do
      @api.delivery_types.status.to_i.must_be :<, 400
    end
  end
end
