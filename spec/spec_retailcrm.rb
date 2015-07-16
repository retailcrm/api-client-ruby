# encoding: utf-8

require 'minitest/autorun'
require 'minitest/spec'

require_relative '../lib/retailcrm'
require_relative './bootstrap'

describe Retailcrm do

  before do
    @bootstrap = Bootstrap.new
    @api = Retailcrm.new(@bootstrap.api_url, @bootstrap.api_key)
  end

end
