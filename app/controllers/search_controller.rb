class SearchController < ApplicationController
    def show
        and_search = params[:a]
        page = params[:p].to_i
        sort = params[:s]
        if(and_search == "true")
            @search_result = and_search(params[:q], sort)
        else 
            @search_result = or_search(params[:q], sort)
        end
        res = []
        search_result_range = @search_result[(page-1)*20...(page*20)]
        if !search_result_range
            search_result_range = []
        end
        search_result_range.each do |movie|
            tags = get_tags_in_movie(movie)
            res.push(createIndex(movie.youtube_id,
                                    movie.channel,
                                    movie.title,
                                    movie.thumbnail,
                                    tags))
        end
        @payload = {
            count: @search_result.length,
            results: res
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

    def or_search(query, sort)        
        @query_tags = query.split(/\s+/)
        match_movies = []
        @query_tags.each do |tag|
            @tagMatched = TagCategory.includes(movies: :tag_categories).find_by(value: tag)
            if @tagMatched
                @tagMatched.movies.each do |movie|
                    match_movies.push(movie)
                end
            end
        end
        case sort
            when "latest"
                match_movies.sort!{|a, b| (-1) * (a.id <=> b.id) }
            when "duration"
                match_movies.sort!{|a, b| (-1) * (a.duration <=> b.duration) }
            when "new_post"                
                match_movies.sort!{|a, b| (-1) * (a.post_time <=> b.post_time) }
            else
                match_movies.sort!{|a, b| (-1) * (a.id <=> b.id) }
        end 
        match_movies.uniq!

        return match_movies
    end

    def and_search(query, sort)        
        @query_tags = query.split(/\s+/)
        match_movies = []
        @query_tags.each_with_index do |tag, i|
            temp = []
            @tagMatched = TagCategory.includes(movies: :tag_categories).find_by(value: tag)
            if @tagMatched
                @tagMatched.movies.each do |movie|
                    temp.push(movie)
                end
                if i == 0
                    match_movies.concat(temp)
                else
                    match_movies = match_movies & temp
                end
            end
        end
        
        match_movies.sort!{|a, b| (-1) * (a.id <=> b.id) }
        match_movies.uniq!

        return match_movies
    end


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
