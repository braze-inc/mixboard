# frozen_string_literal: true

module Mixboard
  # Probably will delete this
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
