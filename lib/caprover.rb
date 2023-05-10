# frozen_string_literal: true

require "open3"

class Caprover
  def initialize
    (@url = ENV["CAPROVER_URL"].presence) || abort("Please define CAPROVER_URL envs")
    (@password = ENV["CAPROVER_PASSWORD"].presence) || abort("Please define CAPROVER_PASSWORD")
    (@app_name = ENV["CAPROVER_APP_NAME"].presence) || abort("Please define CAPROVER_APP_NAME")
    @path = "/user/system/info"
    @data = { appName: @app_name }
  end

  def api(path, method = "GET")
    @out, @err, @status = Open3.capture3(envs(path: path, method: method), "npm run caprover api -- -o #{tmpfile}")
    return @json = JSON.parse(File.read(tmpfile)) if status.success?

    @out
  end

  def envs(path: nil, method: "GET")
    {
      "CAPROVER_API_OUTPUT" => tmpfile,
      "CAPROVER_API_METHOD" => method,
      "CAPROVER_API_DATA" => data.to_json,
      "CAPROVER_API_PATH" => path
    }
  end

  def envs_serialized(method: nil, path: nil)
    envs(method: method, path: path).map { |k, v| "#{k}=#{v}" }.join(" ")
  end

  def data=(attributes)
    @data = { appName: @app_name }
    @data.merge!(attributes)
  end

  def tmpfile
    Rails.root.join("tmp/caprover-#{app_name}.json").to_s
  end

  delegate :success?, to: :status
  attr_reader :data, :app_name, :json, :out, :err, :status

  class << self
    def reset
      @info = nil
      @app_data = nil
      @app_info = nil
    end

    def info
      @info ||= new.api("/user/system/info")
    end

    def app_data
      @app_data ||= begin
        app = new
        app.api("/user/apps/appData/#{app.app_name}")
      end
    end

    def app_info
      @app_info ||= begin
        app = new
        app.api("/user/apps/appDefinitions")
        app.json["appDefinitions"].find { |item| item["appName"] == app.app_name }
      end
    end

    def app_domains
      app_info["customDomain"].map do |item|
        found = app_env.find { |env| env["key"] == "PLAUSIBLE_#{item["publicDomain"].upcase.gsub(".", "_")}" } || {}
        item.merge(plausible: plausible_url(item["publicDomain"], found["value"]))
      end
    end

    def plausible_url(domain, code)
      return unless domain.present? && code.present?

      url = app_env.find { |item| item["key"] == "PLAUSIBLE_URL" }
      return if url.blank?

      "#{url["value"]}/share/#{domain}?auth=#{code}"
    end

    def app_env
      app_info["envVars"]
    end

    def add_env(key, value)
      abort "Var key is not valid (#{key})" unless key.respond_to? :upcase

      clean = app_env.reject { |item| item["key"] == key }
      clean << { "key" => key.upcase, "value" => value.to_s }
      app = new
      app.data = app_info.merge(envVars: clean)
      app.api("/user/apps/appDefinitions/update", "POST")
    end

    def add_domain(domain)
      app = new
      app.data = { customDomain: domain }
      app.api("/user/apps/appDefinitions/customdomain", "POST")
      app.api("/user/apps/appDefinitions/enablecustomdomainssl", "POST")
      abort app.out unless app.success?
    end

    def remove_domain(domain)
      app = new
      app.data = { customDomain: domain }
      app.api("/user/apps/appDefinitions/removecustomdomain", "POST")
      abort app.out unless app.success?
    end
  end
end
