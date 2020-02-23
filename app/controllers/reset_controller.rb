class ResetController < ApplicationController
    require './lib/fetch_movie_data'
    def restore_movie
        @movies = Movie.pluck(:id, :youtube_id)
        hash = {}
        @movies.each do |movie|
            if(movie[1])
                res_data = fetch_movie_data(movie[1], "post")
                duration = res_data["items"][0]["contentDetails"]["duration"]
                length = parse_duration(duration)
                hash.store(movie[0], {duration: length})
            end
        end
        Movie.update(hash.keys, hash.values)
    end
end
