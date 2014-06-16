class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # ssl for production
  # force_ssl

  # simple http basic authentication
  # http_basic_authenticate_with :name => "test", :password => "password"

  include SessionsHelper
end
