class SearchController < ApplicationController
    def show
        @tagMatched = TagCategory.includes(movies: :tag_categories).find_by(value: params[:q])
        results = []
        if @tagMatched
            @tagMatched.movies.each do |movie|
                @movie = Movie.find(movie.id)
                tags = get_tags_in_movie(movie)
                results.push(createIndex(movie.youtube_id,
                                        movie.channel,
                                        movie.title,
                                        movie.thumbnail,
                                        tags))
            end
        end
        results.reverse!
        @payload = {
            count: results.length,
            results: results
        }
        render json: {status: "success", payload: @payload}
    end

    def latest
        @latest_movies = Movie.includes(:tag_categories).last(20).reverse
        results=[]
        @latest_movies.each do |movie|
            tags = get_tags_in_movie(movie)
            results.push(createIndex(
                movie.youtube_id,
                movie.channel,
                movie.title,
                movie.thumbnail,
                tags))
        end
        @payload = {
            count: 20,
            results: results
        }        
        render json: {status: "success", payload: @payload}
    end

    private

    def createIndex(youtube_id, channel, title, thumbnail, tags)
        return {
            youtube_id: youtube_id,
            channel_name: channel,
            title: title,
            thumbnail: thumbnail,
            tags: tags,
            }
    end

    def get_tags_in_movie(movie)
        tags = []
        movie.tag_categories.each do |tag|
            tags.push({
                value: tag.value,
                youtube_id: movie.youtube_id,
                count: tag.tags_count,
            })
        end
        return tags
    end


end
