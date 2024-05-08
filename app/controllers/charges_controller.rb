class ChargesController < ApplicationController
  def new
    render 'charges/new'
  end
  
  def success
    #handle successful charges
    render 'charges/success', notice: "Compra bem sucedida!"
  end
  
  def cancel
    #handle if the charge is cancelled
    render 'charges/cancel', notice: "Falha no processo de compra."
  end
end
