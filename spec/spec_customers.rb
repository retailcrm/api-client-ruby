# encoding: utf-8

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest-spec-context'
require 'pp'

require_relative '../lib/retailcrm'
require_relative './bootstrap'

describe Retailcrm do

  before do
    @bootstrap = Bootstrap.new
    @api = Retailcrm.new(@bootstrap.api_url, @bootstrap.api_key)
    @customer = @bootstrap.customer
  end

  describe '#customers' do
    it 'responds with 200' do
      res = @api.customers({:email => 'test@example.com'}, 50, 1)
      res.status.to_i.must_equal 200
      res.response['customers'].must_be_instance_of Array
      res.response['customers'].each do |x|
        x['email'].must_equal 'test@example.com'
      end
    end
  end

end
