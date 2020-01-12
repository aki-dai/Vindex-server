# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #You should configure your model like this:
  #devise :omniauthable, omniauth_providers: [:twitter]
  include ActionView::Rendering
  require './lib/token_provider'

  attr_reader :current_user
  # You should also create an action method in this controller like this:
  def redirect_callbacks
    auth = request.env['omniauth.auth']
    @user = User.from_omniauth(auth)

    if @user.persisted?
      tokens = Jwt::TokenProvider.refresh_tokens @user
      redirect_path = "http://localhost:8000/auth?"+tokens.to_query
    else
      redirect_path = "http://localhost:8000/?login_error=1"
    end 

    redirect_to redirect_path
  end

  def omniauth_failure

  end


  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
   def passthru
     super
   end

  #GET|POST /users/auth/twitter/callback
  def failure
     super
  end

   private

  #The path used when OmniAuth fails
   def do_callback(omniauth)
   end
end
