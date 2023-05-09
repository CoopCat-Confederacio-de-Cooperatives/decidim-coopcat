# frozen_string_literal: true

class Caprover
  def initialize
    (@url = ENV["CAPROVER_URL"].presence) || abort("Please define CAPROVER_URL envs")
    (@password = ENV["CAPROVER_PASSWORD"].presence) || abort("Please define CAPROVER_PASSWORD")
    (@app_name = ENV["CAPROVER_APP_NAME"].presence) || abort("Please define CAPROVER_APP_NAME")
    @path = "/user/system/info"
    @data = { appName: @app_name }
  end

  def api(path, method = "GET")
    system("#{envs_serialized(path: path, method: method)} npm run caprover api")
  end

  def envs(path: nil, method: "GET")
    {
      "CAPROVER_API_METHOD": method,
      "CAPROVER_API_DATA": "'#{data.to_json}'",
      "CAPROVER_API_PATH": path
    }
  end

  def envs_serialized(method: nil, path: nil)
    envs(method: method, path: path).map { |k, v| "#{k}=#{v}" }.join(" ")
  end

  def data=(attributes)
    @data = { appName: @app_name }
    @data.merge!(attributes)
  end

  attr_reader :data, :app_name

  class << self
    def info
      app = new
      app.api("/user/system/info")
    end

    def app_data
      app = new
      app.api("/user/apps/appData/#{app.app_name}")
    end

    def add_domain(domain)
      app = new
      app.data = { customDomain: domain }
      app.api("/user/apps/appDefinitions/customdomain", "POST")
      app.api("/user/apps/appDefinitions/enablecustomdomainssl", "POST")
    end

    def remove_domain(domain)
      app = new
      app.data = { customDomain: domain }
      app.api("/user/apps/appDefinitions/removecustomdomain", "POST")
    end
  end
end
