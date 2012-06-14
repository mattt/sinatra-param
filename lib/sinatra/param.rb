require 'sinatra/base'
require 'time'
require 'date'

module Sinatra
  module Param
    VERSION = "0.0.1"

    class InvalidParameterError < StandardError; end

    def param(name, type, options = {})
      begin
        params[name] = coerce(params[name], type, options) || options[:default]
        params[name] = options[:transform].to_proc.call(params[name]) if options[:transform]
        validate!(params[name], options)
      rescue
        error = "Invalid parameter, #{name}"
        if content_type && content_type.match(mime_type(:json))
          error = {message: error}.to_json
        end

        halt 406, error
      end
    end

    private

      def coerce(param, type, options = {})
        return nil if param.nil?
        return Integer(param) if type == Integer
        return Float(param) if type == Float
        return String(param) if type == String
        return Time.parse(param) if type == Time
        return Date.parse(param) if type == Date
        return DateTime.parse(param) if type == DateTime
        return Array(param.split(options[:delimiter] || ",")) if type == Array
        return Hash[param.split(options[:delimiter] || ",").map{|c| c.split(options[:separator] || ":")}] if type == Hash
        return ((/(false|f|no|n|0)$/i === param) ? false : (/(true|t|yes|y|1)$/i === param) ? true : nil) if type == Boolean
        return nil
      end

      def validate!(param, options)
        options.each do |key, value|
          case key
            when :required
              raise InvalidParameterError if value && param.nil?
            when :blank
              raise InvalidParameterError if !value && case param
                  when String
                    !(/\S/ === param)
                  when Array, Hash
                    param.empty?
                  else
                    param.nil?
                end
            when :is
              raise InvalidParameterError unless value === param
            when :in, :within, :range
              raise InvalidParameterError unless param.nil? || case value
                  when Range
                    value.include?(param)
                  else
                    Array(value).include?(param)
                  end
            when :min
              raise InvalidParameterError unless param.nil? || value <= param
            when :max
              raise InvalidParameterError unless param.nil? || value >= param
          end
        end
      end
    end

  helpers Param
end
