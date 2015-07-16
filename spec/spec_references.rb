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
    @ref = @bootstrap.refs_edit
  end

  describe '#reference get' do
    it 'responds with 200' do
      @bootstrap.refs_get.each { |method|
        res = @api.public_send(method)
        res.status.to_i.must_equal 200
        sleep 0.3
      }
    end
  end

  describe '#reference edit' do
    it 'responds with 200 or 201' do
      @bootstrap.refs_edit.each do |method, data|
        res = @api.public_send(method, data)
        res.status.to_i.must_be :<, 202
        sleep 0.3
      end
    end
  end

end
