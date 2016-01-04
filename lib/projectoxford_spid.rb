require "projectoxford_spid/version"
require "rest-client"
require "json"
require "open-uri"


module ProjectoxfordSpid
  class SpidError < StandardError
  end

  class RestAPI
    attr_accessor :subscription_key, :url, :version, :api, :headers, :rest

    def initialize(subscription_key, url="https://api.projectoxford.ai/spid", version="v1.0")
      @subscription_key = subscription_key
      @url = url.chomp('/')
      @version = version
      @api = @url + '/' + @version
      @headers = {"Ocp-Apim-Subscription-Key" => @subscription_key}
      @rest = RestClient::Resource.new(@api, headers: @headers)
    end

    def hash_to_params(myhash)
      return myhash.map { |k, v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}" }.join("&")
    end

    def request(method, path, params={}, content_type=nil, options={})
      # Set content_type and accept header
      content_type ? content_type = {:content_type => content_type, :accept => :json} : content_type = {:accept => :json}

      case method
      when "POST"
        # set content to empty hash if its params == {}
        content = params.to_json

        if options[:file] # content set to file when posting a file
          file = options[:file]
          # add params to path if posting a file
          # path = path + "?:"+ hash_to_params(params) if params.any?
          # set content to binary wav file
          file = AudioHero::Sox.new(file).convert(options[:convert]) if options[:convert]
          file = AudioHero::Sox.new(file).remove_silence(options[:remove_silence]) if options[:remove_silence]
          content = file
        end

        begin
          r = @rest[path].post content, content_type
        rescue => e
          response = e
        end

        file.close! # close temp file

        if response # if error
          code = response.http_code
          response = JSON.parse(response.response.to_s)
        else # if success
          code = r.code
          r.to_s == "" ? raw = "{}" : raw = r.to_s
          response = JSON.parse(raw)
          response[:operation_location] = r.headers[:operation_location] if r.headers[:operation_location]
        end
        return [code, response]
      when "GET"
        # add params to path
        path = path + "?" + hash_to_params(params) if params.any?

        begin
          r = @rest[path].get(:accept => :json)
        rescue => e
          response = e
        end

        if response
          code = response.http_code
          response = JSON.parse(response.response.to_s)
        else
          code = r.code
          r.to_s == "" ? raw = "{}" : raw = r.to_s
          response = JSON.parse(raw)
        end

        return [code, response]
      when "DELETE"
        # add params to path
        path = path + "?" + hash_to_params(params) if params.any?
        begin
          r = @rest[path].delete(:accept => :json)
        rescue => e
          response = e
        end
        if response
          code = response.http_code
          response.response.to_s == "" ? raw = "{}" : raw = response.response.to_s
          response = JSON.parse(raw)
          return [code, response]
        else
          code = r.code
          return [code, ""]
        end

      end
      return [405, "Method Not Supported"]
    end

    # Profile
    def create_profile(params={})
      params["locale"] = "en-us" unless params["locale"]
      return request("POST", "/identificationProfiles/", params, "application/json")
    end

    def delete_profile(identification_profile_id)
      return request("DELETE", "/identificationProfiles/#{identification_profile_id}/")
    end

    def get_profiles(params={})
      return request("GET", "/identificationProfiles/")
    end

    def get_profile(identification_profile_id)
      return request("GET", "/identificationProfiles/#{identification_profile_id}/")
    end

    # Usage: client.create_enrollment(id, file_url, {convert: {default: "true", channel: "left", gc: "true"}, remove_silence: {input_format: "wav", gc: "true"}})
    def create_enrollment(identification_profile_id, file_location, options={})
      options[:file] = open(file_location)
      return request("POST", "/identificationProfiles/#{identification_profile_id}/enroll/", {}, "multipart/form-data", options)
    end

    def reset_enrollment(identification_profile_id)
      return request("POST", "/identificationProfiles/#{identification_profile_id}/reset/")
    end

    def get_operation_status(operation_id)
      return request("GET", "/operations/#{operation_id}/")
    end

    # Usage: identification(["id1", "id2"], "file_url", {convert: {channel: "left", gc: "true", default: "true"}, remove_silence: {input_format: "wav", gc: "true"}})
    def identification(identification_profile_ids, file_location, options={})
      options[:file] = open(file_location)
      identification_profile_ids = identification_profile_ids.join(",")
      return request("POST", "/identify?identificationProfileIds=#{identification_profile_ids}")
    end

    def verification(verification_profile_id, file_location, options={})
      options[:file] = open(file_location)
      return request("POST", "/verify?verificationProfileId=#{verification_profile_id}")
    end

  end



end
