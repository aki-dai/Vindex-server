class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    helper_method :current_user, :logged_in?
end
