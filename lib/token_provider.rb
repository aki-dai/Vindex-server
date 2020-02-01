module Jwt
  class TokenProvider
    class << self
      def decode(token)
        JWT.decode token, Rails.application.secrets.secret_key_base
      end

      def refresh_access_token(user)
        user_data = {
          provider:   user.provider,
          uid:        user.uid,
          exp:        Time.current.to_i + 15.minutes
        } 
        access_token = issue_token(user_data)
        
        access_token
      end

      def refresh_tokens(user)
        user_data = {
          provider:   user.provider,
          uid:        user.uid,
        } 
        tokens = Jwt::TokenProvider.create_pair_tokens user_data

        user.update_attribute :refresh_token, tokens[:refresh_token]

        tokens
      end

      def create_pair_tokens(payload)
        {
          access_token: issue_token(payload.merge(exp: Time.current.to_i + 15.minutes)),
          refresh_token: issue_token(payload.merge(exp: Time.current.to_i + 1.months))
        }
      end

      private
      def issue_token(payload)
        JWT.encode payload, Rails.application.secrets.secret_key_base
      end
    end
  end
end