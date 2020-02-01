class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include ActionView::Rendering
    require './lib/token_provider'
    def show
        payload = Jwt::TokenProvider.decode(params[:access_token].split(".")[1])
        if @user = User.find_by(provider: payload.provider, uid: payload.uid)
            user_data = {
                userName: @user.name,
                nickName: @user.nickname,
                image   : @user.image
            }
            render :json {status: 'success', payload: user_data} and return
        else
            render :json {status: 'failed', payload:{error: 'invalid access token'}} and return
        end
    end
        
end