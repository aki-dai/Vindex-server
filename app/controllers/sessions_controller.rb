class SessionsController < ApplicationController
    def create
        user = User.find_or_create_from_auth(request.env['omniauth.auth'])
        session[:user_id] = user.user_id
    end

    def destroy
        reset_session
        redirect_to root_path
    end
end
