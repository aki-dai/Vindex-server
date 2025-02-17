class MoviesController < ApplicationController
    require './lib/fetch_movie_data'
    require './lib/token_provider'

        def create
            begin            
            userData=Jwt::TokenProvider.decode(params[:access_token])
            @user = User.find_by(provider: userData[0]["provider"], uid: userData[0]["uid"])
            @movie = Movie.find_by(youtube_id: params[:youtube_id])
            if !@movie
                res_data = fetch_movie_data(params[:youtube_id], "post")
                if res_data["items"][0]["status"]["privacyStatus"] == "unlisted"
                    return render json: {"status" => "failed", "message" => "Unlisted Movie", "error_code" => "021"}
                end
                title=res_data["items"][0]["snippet"]["title"]
                post_time = DateTime.parse(res_data["items"][0]["snippet"]["publishedAt"])
                channel_name = res_data["items"][0]["snippet"]["channelTitle"]
                thumbnail = res_data["items"][0]["snippet"]["thumbnails"]["medium"]["url"]
                duration = res_data["items"][0]["contentDetails"]["duration"]
                length = parse_duration(duration)
                @movie=Movie.create!({
                    youtube_id: params[:youtube_id],
                    title: title,
                    duration: length,
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
            
            #N+1
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
            rescue Net::OpenTimeout => error
                render json: {"status" => "failed", "message" => "API TimeOut", "error_code" => "011"} and return
            end
        end
        
        def show
            @movie = Movie.find_by(youtube_id: params[:id])
            if !@movie
                render json:{"status" => "failed", "message" => "存在しない動画です。", "error_code" => "101"} and return
            end
            @tag = Tag.where(movie_id: @movie.id)
            @tag_return = []
            @tag.includes([:users, :tag_category]).each do |t|
                @user = User.find(t.latest_user_id)
                @tag_category  = t.tag_category
                @tag_return.push(tag_format(@user.uid, @user.name, @tag_category.value, @movie.youtube_id))
            end
            @payload = {
                "movie": @movie,
                "tag": @tag_return,
            }
            render json: {"status" => "success", "message" => "Tagを表示します", "payload" => @payload}
        end

        def update   
            begin                     
                userData=Jwt::TokenProvider.decode(params[:access_token])
                @user = User.find_by(provider: userData[0]["provider"], uid: userData[0]["uid"])
                @movie = Movie.find_by(youtube_id: params[:youtube_id])
                if !@movie
                    render json:{"status" => "failed", "message" => "存在しない動画です。", "error_code" => "101"} and return
                end
                @new_tags = params[:payload][:tags].map{|t| t[:value]}
                @current_movie_tags = @movie.tag_categories.map{|t| t[:value]}
                @duplicated_tags = @current_movie_tags & @new_tags
                @added_tags = @new_tags - @duplicated_tags
                @deleted_tags =  @current_movie_tags - @duplicated_tags
                @added_tags.each do |new_tag_value|
                    @tag_category = TagCategory.find_or_create_by(value: new_tag_value)
                    @tag_category.movies << @movie
                    @tag = Tag.find_by(movie_id: @movie.id, tag_category_id: @tag_category.id)
                    @tag.update(latest_user_id: @user.id)
                    @tag.users << @user
                end

                @deleted_tags.each do |delete_tag|
                    @tag_category = TagCategory.find_by(value: delete_tag)
                    if @tag_category
                        @tag_category.movies.destroy(@movie)                
                    end
                end
                    render json:{"status" => "success", "message" => "タグの更新が完了しました。"}   
  
                
            rescue JWT::ExpiredSignature => error
                render json: {"status"=> "failed", "message" => "access token expired", "error_code" => "001"} and return
            rescue Net::OpenTimeout => error
                render json: {"status" => "failed", "message" => "API TimeOut", "error_code" => "011"} and return
            end
        end

        def destroy
            
        end

        def fetch
            @movie = Movie.find_by(youtube_id: params[:youtubeID])
            @tag_return = []
            if @movie
                @tag = Tag.where(movie_id: @movie.id)
                @tag.includes([:users, :tag_category]).each do |t|
                    @user = User.find(t.latest_user_id)
                    @tag_category  = t.tag_category
                    @tag_return.push(tag_format(@user.uid, @user.name, @tag_category.value, @movie.youtube_id))
                end
                movie_data = {
                    "title": @movie.title,
                    "channelName": @movie.channel,
                    "state": "registered",
                    "tag": @tag_return,
                }
            else
                begin 
                    res_data = fetch_movie_data(params[:youtubeID], "fetch")
                    #if res_data["items"][0]["status"]["privacyStatus"] == "unlisted"
                    #    return render json: {"status" => "failed", "message" => "Unlisted Movie", "error_code" => "021"}
                    #end
                    movie_data = {
                        "title": res_data["items"][0]["snippet"]["title"],
                        "channelName": res_data["items"][0]["snippet"]["channelTitle"],
                        "state": "unregistered",
                        "tag": @tag_return, 
                    }
                rescue Net::OpenTimeout => error
                    render json: {"status" => 'failed', "message" => 'API TimeOut', "error_code" => '011'} and return
                end
            end
            render :json => {"status": 'success', "payload": movie_data}
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