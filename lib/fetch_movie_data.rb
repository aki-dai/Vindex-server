require "resolv-replace"

def fetch_movie_data(youtube_id, fetch_type)
    if fetch_type == "post"
        query_data ={
            "part": "snippet, contentDetails, status",
            "id": youtube_id,
            "key": ENV['YOUTUBE_API_KEY']
        }
    else
        query_data ={
            "part": "snippet, status",
            "id": youtube_id,
            "key": ENV['YOUTUBE_API_KEY']
        }
    end
    query=query_data.to_query
    uri = URI.parse("https://www.googleapis.com/youtube/v3/videos?"+query)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 5
    http.read_timeout = 5
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    #http.get(uri)
    res = http.get(uri)
    res_data = JSON.parse(res.body)
    #logger.debug(status)
    return res_data
end