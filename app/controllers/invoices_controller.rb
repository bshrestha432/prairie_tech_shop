class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def show
    @invoice = current_user.invoices.find(params[:id])
  end
end
