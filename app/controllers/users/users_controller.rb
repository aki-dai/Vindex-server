class Users::OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include ActionView::Rendering
  end