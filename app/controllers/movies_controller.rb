class MoviesController < ApplicationController
        def create

           if !Movie.find_by(youtube_id: params[:youtube_id])
               @movie=Movie.create(movie_params)
           else
               render json: {"status":"already posted!"} and return
           end
           render json: @movie
        end
        
        def update
        end

        def destroy
        end

        def fetch
            data ={
                "part": "snippet",
                "id": params[:youtubeID],
                "key": ENV['YOUTUBE_API_KEY']
            }
            query=data.to_query
            uri = URI.parse("https://www.googleapis.com/youtube/v3/videos?"+query)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            req = Net::HTTP::Get.new(uri)
            res = http.request(req)
            res_data = JSON.parse(res.body)
            
            return_data = {
                "title": res_data["items"][0]["snippet"]["title"],
                "channelName": res_data["items"][0]["snippet"]["channelTitle"]
            }
            render :json => return_data
        end

        private
        
        def movie_params
            params.permit(:youtube_id, :post_user, :uid)
            
        end
end