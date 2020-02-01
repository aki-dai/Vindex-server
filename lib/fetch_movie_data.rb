def fetch_movie_data(youtube_id, fetch_type)
    if fetch_type == "post"
        query_data ={
            "part": "snippet, contentDetails",
            "id": youtube_id,
            "key": ENV['YOUTUBE_API_KEY']
        }
    else
        query_data ={
            "part": "snippet",
            "id": youtube_id,
            "key": ENV['YOUTUBE_API_KEY']
        }
    end
    logger.debug(query_data)
    query=query_data.to_query
    uri = URI.parse("https://www.googleapis.com/youtube/v3/videos?"+query)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    res_data = JSON.parse(res.body)
    return res_data
end