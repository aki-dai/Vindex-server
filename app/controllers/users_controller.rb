class UsersController < ApplicationController
    include ActionView::Rendering
    require './lib/token_provider'
    def show
        payload = Jwt::TokenProvider.decode(params[:access_token])
        if @user = User.find_by(provider: payload[0]["provider"], uid: payload[0]["uid"])
            user_data = {
                userName: @user.name,
                nickName: @user.nickname,
                image:    @user.image,
            }
            render json: {status: 'success', payload: user_data} and return
        else
            render json: {status: 'failed', payload:{error: 'invalid access token', payload: payload[0]}} and return
        end
    end
end
