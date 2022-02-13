# frozen_string_literal: true

class BillingService < BaseService
  def initialize(params)
    @params = params
  end

  def perform
    @total = 0
    @free = []
    @billing = []
    @sales_tax = 0
    @net_total = 0
    @billing_cart = []
    @unavailable_products = []

    scan_cart

    { billing: @billing, free: @free, unavailable: @unavailable_products, net_total: @net_total,
      sales_tax: @sales_tax }
  end

  private

  def get_product_count(product_id)
    product_index = @billing_cart.index { |item| item[:product] == product_id }

    if product_index.nil?
      @billing_cart.push({ product: product_id, count: 1 })
    else
      @billing_cart[product_index][:count] += 1
    end
  end

  def scan_cart
    @params[:cart].length.times do |index|
      product = Product.find_by_code(@params[:cart][index])

      if product.present?
        get_product_count(product.id)
      else
        @unavailable_products.push(@params[:cart][index])
      end
    end

    generate_bill
    add_sales_tax
    exclude_free
  end

  def generate_bill
    @billing_cart.each do |cart_item|
      product = Product.find(cart_item[:product])

      regular_bill = if product.volume.nil? || product.volume.zero?
                       cart_item[:count] * product.price
                     else
                       check_volumes cart_item
                     end

      total = regular_bill

      add_to_billing_list(product.code, cart_item[:count], total)
      next unless product.has_addon

      got_free = cart_item[:count] / product.free_criteria
      product.free_products.each do |free_product|
        add_to_free_list(free_product, got_free)
      end
    end
  end

  def add_to_free_list(product, no_of_free)
    product_index = @free.index { |item| item[:product] == product.free.code }

    if product_index.nil?
      @free.push({ product: product.free.code, count: no_of_free })
    else
      @free[product_index][:count] += no_of_free
    end
  end

  def add_to_billing_list(product, count, price)
    @billing.push({ product: product, count: count, total_price: price })
    @total += price
  end

  def add_sales_tax
    @sales_tax = @total * 0.1
    @net_total = @total + @sales_tax
  end

  def exclude_free
    @free.each do |free|
      @billing.each do |billing|
        next unless billing[:product] == free[:product]

        x = billing[:count] >= free[:count] ? free[:count] : billing[:count]

        next unless x

        product = Product.find_by_code(billing[:product])
        reducted_amount = x * product.price
        reducted_amount += reducted_amount * 0.1
        @net_total -= reducted_amount
      end
    end
  end

  def check_volumes(cart_item)
    product = Product.find(cart_item[:product])
    pack_price = (cart_item[:count] / product.volume.to_i) * product.volume_price
    reg_price = (cart_item[:count] % product.volume.to_i) * product.price

    pack_price + reg_price
  end
end
