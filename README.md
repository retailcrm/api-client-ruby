[![Gem Version](https://badge.fury.io/rb/retailcrm.svg)](http://badge.fury.io/rb/retailcrm)

retailCRM API ruby client
=========================


### Install

```
gem install retailcrm
```

### Examples

#### Get order

```ruby
require 'retailcrm'

api = Retailcrm.new('https://yourcrmname.retailcrm.pro', 'yourApiKeyHere')

response = api.orders_get(345, 'id').response
order = response[:order]

```

#### Create order

```ruby
require 'retailcrm'

api = Retailcrm.new('https://yourcrmname.retailcrm.pro', 'yourApiKeyHere')

order = {
  :externalId => 171,
  :number => '171',
  :email => 'test@example.com',
  :createdAt => '2014-10-28 19:31:10',
  :discountPercent => 10,
  :firstName => 'Jack',
  :lastName => 'Daniels',
  :customer => {
    :externalId => 8768,
    :firstName => 'Jack',
    :lastName => 'Daniels',
    :phones => [{ :number => '+79000000000' }],
  },
  :delivery => {
    :code => 'courier',
    :cost => 500,
    :address => {:text => '300000, Russia, Moscow, Tverskaya st., 56'}
  },
  :items => [
    {
      :productId => 170,
      :initialPrice => 500,
      :quantity => 2
    },
    {
      :productId => 175,
      :initialPrice => 1300,
      :quantity => 1
    }
  ]
}

response = api.orders_create(order).response
order_id = response[:id]

```

#### Documentation

* http://www.retailcrm.pro/docs/Developers/ApiVersion3
* http://www.rubydoc.info/gems/retailcrm
