# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  #You should configure your model like this:
  #devise :omniauthable, omniauth_providers: [:twitter]
  include ActionView::Rendering
  # You should also create an action method in this controller like this:
  def redirect_callbacks
    auth = request.env['omniauth.auth']
    user_data = {
      provider:   auth.provider,
      uid:        auth.uid,
      name:       auth.info.name,
      nickname:   auth.info.nickname,
      image:      auth.info.image,
    } 

    unless User.find_by(uid: auth.uid)
      user = User.new(user_data)
      user.save!
    end

    response = {
      success: true,
      profile: user_data,
    }
    redirect_to 'http://localhost:8000/', success: true, profile: user_data 
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
