module Position
  def fetch uri_str, limit = 3
    raise ArgumentError, "HTTP redirect too deep" if limit == 0

    # response = Net::HTTP.get_response(URI.parse(uri_str))
    uri_str = URI.encode(uri_str)
    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      fetch(response["location"], limit - 1)
    else
      response.value
    end
  end

  def find_position(full_address)
    request = "http://maps.googleapis.com/maps/api/geocode/json?address=#{full_address}"
    response = fetch(request)
    temp = response.body
    temp = JSON.parse(temp)

    lat = temp["results"][0]["geometry"]["location"]["lat"].to_f
    lng = temp["results"][0]["geometry"]["location"]["lng"].to_f
    return lat, lng
  end
end
