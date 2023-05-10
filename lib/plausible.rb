# frozen_string_literal: true

require "open3"

class Plausible
  def initialize
    (@url = ENV["PLAUSIBLE_URL"].presence) || abort("Please define PLAUSIBLE_URL envs")
    (@api_key = ENV["PLAUSIBLE_API_KEY"].presence) || abort("Please define PLAUSIBLE_API_KEY")
    @params = {}
    @connection = Faraday.new(
      url: @url,
      params: params,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{@api_key}"
      }
    )
  end

  def get(path)
    @response = connection.get("/api/v1/#{path}")
    abort response.body unless success?
    JSON.parse response.body
  end

  def put(path, data)
    @response = connection.put("/api/v1/#{path}") do |req|
      req.body = data.to_json
    end
    abort response.body unless success?
    JSON.parse response.body
  end

  def post(path, data)
    @response = connection.post("/api/v1/#{path}") do |req|
      req.body = data.to_json
    end
    abort response.body unless success?
    JSON.parse response.body
  end

  delegate :success?, to: :response
  attr_reader :connection, :response, :params

  class << self
    def info(domain)
      @info ||= new.get("sites/#{domain}")
    end

    def add_domain(domain)
      begin info(domain)
      rescue SystemExit
        # create the site in plausible
        new.post("sites", { domain: domain, timezone: "Europe/Madrid" })
      end

      new.put("sites/shared-links", { name: "Cercles", site_id: domain })
    end
  end
end
