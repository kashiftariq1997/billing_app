# frozen_string_literal: true

class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_product, only: %i[show update destroy]

  def index
    render json: { products: products }, status: 200
  end

  def show
    if @product.present?
      render json: { product: get_json(@product) }, status: 200
    else
      render json: {}, status: 204
    end
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      render json: { message: 'Product created successfully', product: @product }, status: 201
    else
      render json: { message: @product.errors }, status: 500
    end
  end

  def update
    return render json: { message: 'Product not found!' }, status: 404 if @product.nil?

    return render json: { message: @product.errors }, status: 500 unless @product.update(product_params)

    render json: { message: 'Product updated successfully' }, status: 200
  end

  def destroy
    return render json: { message: 'Product not found!' }, status: 404 if @product.nil?

    return render json: { message: @product.errors }, status: 500 unless @product.destroy

    render json: { message: 'Product deleted successfully' }, status: 200
  end

  private

  def product_params
    params.require(:product).permit(:code, :price, :volume, :volume_price, :has_addon, :product_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def products
    items_per_page = params.key?(:items_per_page) ? params[:items_per_page] : 10

    Product.all.paginate(page: params[:page], per_page: items_per_page).map do |product|
      get_json(product)
    end
  end

  def get_json(product)
    { code: product.code, price: product.price, volume: product.volume, volume_price: product.volume_price }
  end
end
