class ApplicationController < ActionController::API
    
    def parse_duration(duration)
        reptms=/^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$/
        hours, minutes, seconds = 0, 0, 0
        matches = duration.match(reptms)
        if(matches[1]) 
            hours = matches[1].to_i
        end
        if(matches[2])
            minutes = matches[2].to_i
        end
        if(matches[3])
            seconds = matches[3].to_i
        end
        p matches[0]
        totalseconds = hours * 3600 + minutes *60 + seconds
        totalseconds
    end

    include DeviseTokenAuth::Concerns::SetUserByToken
    helper_method :current_user, :logged_in?
end
