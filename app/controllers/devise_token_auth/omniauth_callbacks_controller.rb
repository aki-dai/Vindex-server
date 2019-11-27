class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include ActionView::Rendering
    def omniauth_failure
    end

    def omniauth_success
        
    end
end