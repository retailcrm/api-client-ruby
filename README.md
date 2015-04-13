Ruby-клиент для retailCRM API
=============================


### Установка

```
gem install retailcrm
```

### Примеры использования

#### Получение информации о заказе

```ruby
require 'retailcrm'

api = Retailcrm.new('https://yourcrmname.intarocrm.ru', 'yourApiKeyHere')

response = api.orders_get(345, 'id').get_response
order = response[:order]

```

#### Создание заказа

```ruby
require 'retailcrm'

api = Retailcrm.new('https://yourcrmname.intarocrm.ru', 'yourApiKeyHere')

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

response = api.orders_create(order).get_response
order_id = response[:id]

```

#### REST API Documentation

http://www.retailcrm.ru/docs/Разработчики/СправочникМетодовAPIV3

