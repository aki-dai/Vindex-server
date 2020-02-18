class SearchController < ApplicationController
    def show
        @tagMatched = TagCategory.find_by(value: params[:q])
        results = []
        if @tagMatched
            @tagMatched.movies.each do |movie|
                @movie = Movie.find(movie.id)
                tags = []
                @movie.tag_categories.each do |tag|
                    tags.push({
                        value: tag.value,
                        youtube_id: @movie.youtube_id,
                        count: tag.tags_count,
                    })
                end
                results.push(createIndex(@movie.youtube_id,
                                        @movie.channel,
                                        @movie.title,
                                        @movie.thumbnail,
                                        tags))
            end
        end
        @payload = {
            count: results.length,
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
end
