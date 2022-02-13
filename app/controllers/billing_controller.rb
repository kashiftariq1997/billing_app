# frozen_string_literal: true

class BillingController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: { billing: billing }, status: 200
  end

  private

  def billing
    BillingService.perform(params)
  end
end
