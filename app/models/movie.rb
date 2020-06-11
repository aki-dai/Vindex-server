class Movie < ApplicationRecord
    require './lib/fetch_movie_data'

    has_many :tags
    has_many :tag_categories, through: :tags
    belongs_to :user
    
    def self.update_info
        @movies = self.all
        @movies.each do |movie|
            if !movie.uid
                next
            end
            res_data = fetch_movie_data(movie.youtube_id, "post")
            title=res_data["items"][0]["snippet"]["title"]
            post_time = DateTime.parse(res_data["items"][0]["snippet"]["publishedAt"])
            channel_name = res_data["items"][0]["snippet"]["channelTitle"]
            #thumbnail = res_data["items"][0]["snippet"]["thumbnails"]["medium"]["url"]
            duration = res_data["items"][0]["contentDetails"]["duration"]
            length = parse_duration(duration)
            movie.update(title: title, post_time: post_time, channel: channel_name)
        end

        private
        
    end
end
