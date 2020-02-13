class MoviesController < ApplicationController
    require './lib/fetch_movie_data'
    require './lib/token_provider'

        def create
            begin            
            userData=Jwt::TokenProvider.decode(params[:access_token])
            @user = User.find_by(provider: userData[0]["provider"], uid: userData[0]["uid"])
            @movie = Movie.find_by(youtube_id: params[:youtube_id])
            if !@movie
                logger.debug(@user)
                res_data = fetch_movie_data(params[:youtube_id], "post")
                title=res_data["items"][0]["snippet"]["title"]
                post_time = res_data["items"][0]["snippet"]["publishedAt"]
                channel_name = res_data["items"][0]["snippet"]["channelTitle"]
                thumbnail = res_data["items"][0]["snippet"]["thumbnails"]["medium"]["url"]
                duration = res_data["items"][0]["contentDetails"]["duration"]
                logger.debug(duration)
                @movie=Movie.create!({
                    youtube_id: params[:youtube_id],
                    title: title,
                    duration: duration,
                    channel: channel_name,
                    post_time: post_time,
                    thumbnail: thumbnail,
                    post_user: @user.name,
                    uid: userData[0]["uid"],
                    provider: userData[0]["provider"],
                    user_id: @user.id,
                })                   
                @user.movies << @movie
            end
           
            params[:payload][:tags].each do |tag|
                @tag_category = TagCategory.find_or_create_by(value: tag[:value])
                @tag_category.movies << @movie
                @tag = Tag.find_by(movie_id: @movie.id, tag_category_id: @tag_category.id)
                @tag.update(latest_user_id: @user.id)
                @tag.users << @user
            end                    

            render json: {"status" => "success", "message" => "新しく動画登録しました", "payload" => "#{@movie}"}
            
                
            rescue JWT::ExpiredSignature => error
                render json: {"status"=> "failed", "message" => "access token expired", "error_code" => "001"}
            end
        end
        
        def show
            @movie = Movie.find_by(youtube_id: params[:id])
            @tag = Tag.where(movie_id: @movie.id)
            @tag_return = []
            @tag.each do |t|
                @user = User.find(t.latest_user_id)
                @tag_category  = t.tag_category
                @tag_return.push(tag_format(@user.uid, @user.name, @tag_category.value, @movie.youtube_id))
            end
            @payload = {
                "movie": @movie,
                "tag": @tag_return,
            }
            render json: {"status" => "success", "message" => "Tagを表示します", "payload" => "#{@payload}"}
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

        def tag_format(userID, userName, value, youtubeID)
            return{
                contributer:{
                    userID: userID,
                    userName: userName,
                },
                value: value,
                youtubeID: youtubeID,
            }
        end
end