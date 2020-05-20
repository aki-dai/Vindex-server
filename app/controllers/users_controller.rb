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
            logger.debug(user_data)
            render json: {status: 'success', payload: user_data} and return
        else
            render json: {status: 'failed', payload:{error: 'invalid access token', error_code: "001"}} and return
        end
    end

    def update
        if @user = User.find_by(refresh_token: params[:refresh_token])
            new_access_token = Jwt::TokenProvider.refresh_access_token(@user)
            render json: {status: 'success', payload: {access_token: new_access_token}} and return                        
        else 
            render json: {status: 'failed', payload:{error: 'invalid refresh token', error_code: "002"}} and return
        end
    end
end
