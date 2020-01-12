class ApplicationController < ActionController::API
    include DeviseTokenAuth::Concerns::SetUserByToken
    include Jwt
end
