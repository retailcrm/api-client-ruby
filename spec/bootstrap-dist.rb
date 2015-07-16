# encoding: utf-8

class Bootstrap

  attr_reader :api_key, :api_url, :order, :customer, :refs_get, :refs_edit

  def initialize
    @api_url = 'https://demo.retailcrm.ru'
    @api_key = 'YourAPIKeyRightHere'

    id   = Time.now.to_i
    time = Time.now.strftime('%F %T')

    @customer = {
        :externalId => id,
        :createdAt => time,
        :firstName => 'API',
        :lastName => 'Test',
        :email => 'pupkin@example.org',
        :phones => [{:number => '+79099099090'}]
    }

    @order = {
        :create => {
            :externalId => id,
            :number => "#{id}",
            :orderType => 'eshop-individual',
            :orderMethod => 'phone',
            :createdAt => time,
            :discountPercent => 10,
            :firstName => 'API',
            :lastName => 'Test',
            :customer => {
                :firstName => 'Тестовый',
                :lastName => 'Клиент',
                :phones => [{:number => '+79099099090'}],
            },
            :delivery => {
                :code => 'courier',
                :cost => 500,
                :address => {:text => '344000, Ростов-на-Дону, пр. Буденовский, 13'}
            },
            :status => 'new',
            :items => [
                {
                    :productName => 'Товар 1',
                    :initialPrice => 500,
                    :quantity => 2
                },
                {
                    :productName => 'Товар 2',
                    :initialPrice => 1300,
                    :quantity => 1
                }
            ]
        },
        :edit => {
            :externalId => 1428877985,
            :email => 'spec@example.org',
            :phone => '+79999999999',
            :status => 'cancel-other',
            :delivery => {
                :code => 'ems',
                :cost => 300,
            }
        },
        :mass => [
            {
                :externalId => id,
                :number => "#{id}",
                :orderType => 'eshop-individual',
                :orderMethod => 'phone',
                :createdAt => time,
                :discountPercent => 10,
                :firstName => 'API',
                :lastName => 'Test',
                :customer => {
                    :firstName => 'Тестовый',
                    :lastName => 'Клиент',
                    :phones => [{:number => '+79099099090'}],
                },
                :delivery => {
                    :code => 'courier',
                    :cost => 500,
                    :address => {:text => '344000, Ростов-на-Дону, пр. Буденовский, 13'}
                },
                :status => 'new',
                :items => [
                    {
                        :productName => 'Товар 1',
                        :initialPrice => 500,
                        :quantity => 2
                    },
                    {
                        :productName => 'Товар 2',
                        :initialPrice => 1300,
                        :quantity => 1
                    }
                ]
            },
            {
                :externalId => id+1,
                :number => "#{id+1}",
                :orderType => 'eshop-individual',
                :createdAt => time,
                :discount => 200,
                :firstName => 'API2',
                :lastName => 'Test2',
                :customer => {
                    :firstName => 'Тестовый2',
                    :lastName => 'Клиент2',
                    :phones => [{:number => '+79099099000'}],
                },
                :delivery => {
                    :code => 'ems',
                    :cost => 500,
                    :address => {:text => '344000, Ростов-на-Дону, пр. Буденовский, 15'}
                },
                :status => 'availability-confirmed',
                :items => [
                    {
                        :productName => 'Товар 3',
                        :initialPrice => 500,
                        :quantity => 2
                    },
                    {
                        :productName => 'Товар 4',
                        :initialPrice => 1300,
                        :quantity => 1
                    }
                ]
            }
        ]
    }

    @refs_get = %w(
      delivery_services
      delivery_types
      order_methods
      order_types
      payment_statuses
      payment_types
      product_statuses
      status_groups
      statuses
      sites
      stores
    )

    @refs_edit = {
        delivery_types_edit: {
            name: 'Rake delivery type',
            code: 'rake-delivery-type',
            defaultCost: 300,
            defaultNetCost: 0,
            description: 'Test delivery type through Rake test task'
        },
        delivery_services_edit: {
            name: 'Rake delivery service',
            code: 'rake-delivery-service',
            deliveryType: 'rake-delivery-type'
        },
        order_methods_edit: {
            name: 'Rake order method',
            code: 'rake-order-method',
        },
        order_types_edit: {
            name: 'Rake order type',
            code: 'rake-order-type',
        },
        payment_statuses_edit: {
            name: 'Rake payment status',
            code: 'rake-payment-status',
            description: 'Test payment status through Rake test task'
        },
        payment_types_edit: {
            name: 'Rake payment type',
            code: 'rake-payment-type',
            description: 'Test payment type through Rake test task'
        },
        product_statuses_edit: {
            ordering: 65,
            name: 'Rake product status',
            code: 'rake-payment-type',
            cancelStatus: true,
            orderStatusByProductStatus: 'cancel-other',
        },
        statuses_edit: {
            name: 'Rake status',
            code: 'rake-status',
            group: 'new',
        },
        sites_edit: {
            name: 'Rake Shop',
            url: 'http://yandex.ru',
            code: 'api-client-all',
            loadFromYml: false,
        },
        stores_edit: {
            type: 'store-type-online',
            code: 'rake-store',
            name: 'Rake Store'
        }
    }
  end
end

