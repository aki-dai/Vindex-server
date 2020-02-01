class MoviesController < ApplicationController
    require './lib/fetch_movie_data'
    require './lib/token_provider'

        def create
            if !Movie.find_by(youtube_id: params[:youtube_id])
                begin
                    payload=Jwt::TokenProvider.decode(params[:access_token])
                    @user = User.find_by(provider: payload[0]["provider"], uid: payload[0]["uid"])
                    logger.debug(@user)
                    res_data = fetch_movie_data(params[:youtube_id], "post")
                    title=res_data["items"][0]["snippet"]["title"]
                    post_time = res_data["items"][0]["snippet"]["publishedAt"]
                    channel_name = res_data["items"][0]["snippet"]["channelTitle"]
                    thumnail = res_data["items"][0]["snippet"]["thumbnails"]["medium"]["url"]
                    duration = res_data["items"][0]["contentDetails"]["duration"]
                    logger.debug(duration)
                    @movie=Movie.new({
                        youtube_id: params[:youtube_id],
                        title: title,
                        duration: duration,
                        channel: channel_name,
                        post_time: post_time,
                        thumnail: thumnail,
                        post_user: @user.name,
                        uid: payload[0]["uid"],
                        provider: payload[0]["provider"],
                    })
                    if @movie.save
                        render json: {"status" => "success", "message" => "新しく動画登録しました", "payload" => "#{@movie}"}
                    end
                rescue JWT::ExpiredSignature => error
                    logger.debug(error)
                    render json: {"status"=> "failed", "message" => "access token expired", "error_code" => "001"}
                end
            else
               render json: {"status": "already posted!"} and return
            end
        end
        
        def update
        end

        def destroy
        end

        def fetch
            res_data = fetch_movie_data(params[:youtubeID], "fetch")

            logger.debug "#{res_data}"
            movie_data = {
                "title": res_data["items"][0]["snippet"]["title"],
                "channelName": res_data["items"][0]["snippet"]["channelTitle"]
            }
            render :json => {status: 'success', payload: movie_data}
        end

        private
        
        def movie_params
            params.permit(:youtube_id, :post_user, :uid)
            
        end
end