class MoviesController < ApplicationController
        def create

           if !Movie.find_by(youtube_id: params[:youtube_id])
               @movie=Movie.create(movie_params)
           else
               render json: {"status":"already posted!"} and return
           end
           redirect_to '/mypage'
        end
        
        def update
        end

        def destroy
        end

        private
        
        def movie_params
            params.permit(:youtube_id, :post_user, :uid)
            
        end
end