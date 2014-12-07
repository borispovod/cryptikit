require 'json'
require 'uri'

class CryptiApi
  def initialize(task)
    @task = task
  end

  DEFAULT_ARGS = [
    '--silent',
    '--header', '"Content-Type: application/json"',
    '--connect-timeout', '30',
    '--max-time', '60'
  ]

  def get(url, data = nil, &block)
    begin
      body = @task.capture *curl('-X', 'GET', encode_url(url, data))
      json = JSON.parse(body)
    rescue Exception => exception
      error = CurlError.new(@task, exception)
      error.detect
      json = {}
    end
    if block_given? and json['success'] then
      block.call json
    end
    return json
  end

  def post(url, data = {}, &block)
    begin
      body = @task.capture *curl('-X', 'POST', '-d', "'#{data.to_json}'", encode_url(url))
      json = JSON.parse(body)
    rescue Exception => exception
      error = CurlError.new(@task, exception)
      error.detect
      json = {}
    end
    if block_given? and json['success'] then
      block.call json
    end
    return json
  end

  def encode_url(url, data = nil)
    url  = "'http://127.0.0.1:#{CryptiKit.app_port}#{url}"
    url << "?#{URI.encode_www_form(data)}" if data
    url << "'"
    url
  end

  private

  def curl(*args)
    ['curl', DEFAULT_ARGS, args].flatten!
  end
end
