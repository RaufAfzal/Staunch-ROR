require 'net/http'
require 'json'

class EmployeeApiService
  BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

  def initialize
    uri = URI.parse(BASE_URL)
    @http = Net::HTTP.new(uri.host, uri.port)
    @http.use_ssl = (uri.scheme == 'https')
  end

  def index(page = nil)
    uri = build_uri("page=#{page}")
    get_request(uri)
  end
  
  def show(id)
    uri = build_uri(id)
    get_request(uri)
  end

  def create(params)
    uri = build_uri(params[:id])
    post_request(uri, params)
  end

  def update(id, params)
    uri = build_uri(id)
    put_request(uri, params)
  end

  private

  def build_uri(path = '')
    if path&.include?('page')
      URI("#{BASE_URL}?#{path}")
    else
      URI("#{BASE_URL}/#{path}")
    end
  end

  def get_request(uri)
    make_request(Net::HTTP::Get.new(uri))
  end

  def post_request(uri, params)
    request = Net::HTTP::Post.new(uri)
    set_request_headers(request)
    request.body = params.to_json
    make_request(request)
  end

  def put_request(uri, params)
    request = Net::HTTP::Put.new(uri)
    set_request_headers(request)
    request.body = params.to_json
    make_request(request)
  end

  def set_request_headers(request)
    request['Content-Type'] = 'application/json'
  end

  def make_request(request)
    response = @http.request(request)
    { code: response.code, body: response.body }
  end
end
