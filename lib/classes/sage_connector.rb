class SageConnector
  def initialize(address="", password)
    @debug = !(address && address != "")

    @address  = address
    @password = password

    @address = "#{@address}/" unless @address.ends_with? "/"

    @http = create_http_object
  end

  def debug?
    @debug || Rails.env.test?
  end

  def test_connection
    return debug? || url_connects?
  end

  def url_connects?
    return false unless @http
    return true if debug?

    begin
      request = Net::HTTP::Get.new(@address)
      res = @http.request(request)
      return true
    rescue Net::OpenTimeout => e
      return false
    rescue SocketError => e
      return false
    rescue Errno::ECONNREFUSED => e
      return false
    rescue Errno::EHOSTUNREACH => e
      return false
    end
  end

  def create_http_object
    return :fake_http if debug?

    # Bail out if the url is invalid
    return false unless @address =~ URI::regexp

    begin
      # Generate test request and send
      url = URI.parse(@address)

      http = Net::HTTP.new(url.host, url.port)
      http.read_timeout = 10
      http.open_timeout = 5

      if url.scheme == "https"
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      return http
    rescue OpenTimeout => e
      return nil
    rescue SocketError => e
      return nil
    end
  end

  def post_data(obj, action, data={}.to_json)
    return "0" if debug?

    payload = {
      :obj      => obj,
      :action   => action,
      :data     => data,
      :password => @password
    }.to_json

    begin
      request = Net::HTTP::Post.new(@address)
      request.body = payload

      res = @http.request(request)
      return res.body
    rescue SocketError => e
      return nil
    end
  end

  def get_data(obj, action, data={}.to_json)
    return "{}" if debug?

    payload = {
      :obj      => obj,
      :action   => action,
      :data     => data,
      :password => @password
    }.to_json

    begin
      request = Net::HTTP::Post.new(@address)
      request.body = payload

      res = @http.request(request)
      return res.body
    rescue SocketError => e
      return nil
    end
  end
end
