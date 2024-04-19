class HomeController < ApplicationController
  def index
    required_login
  end
end
