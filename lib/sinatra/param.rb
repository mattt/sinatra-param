require 'sinatra/base'
require 'sinatra/param/version'
require 'time'
require 'date'

module Sinatra
  module Param
    Boolean = :boolean

    class InvalidParameterError < StandardError
      attr_accessor :param, :options
    end

    def param(name, type, options = {})
      name = name.to_s

      return unless params.member?(name) or present?(options[:default]) or options[:required]

      begin
        params[name] = coerce(params[name], type, options)
        params[name] = default_value(options[:default]) if params[name].nil? and options[:default]
        params[name] = options[:transform].to_proc.call(params[name]) if options[:transform]
        validate!(params[name], options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = name, options
          raise exception
        end

        error = "Invalid Parameter: #{name}"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {name => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    def one_of(*names)
      count = 0
      names.each do |name|
        if params[name] and present?(params[name])
          count += 1
          next unless count > 1

          error = "Parameters #{names.join(', ')} are mutually exclusive"
          if content_type and content_type.match(mime_type(:json))
            error = {message: error}.to_json
          end

          halt 400, error
        end
      end
    end

    private

    def default_value(default)
      (default.is_a?(Proc) ? default.call : default)
    end

    def coerce(param, type, options = {})
      return nil if param.nil?
      return param if (param.is_a?(type) rescue false)
      return Integer(param) if type == Integer
      return Float(param) if type == Float
      return String(param) if type == String
      return Time.parse(param) if type == Time
      return Date.parse(param) if type == Date
      return DateTime.parse(param) if type == DateTime
      return Array(param.split(options[:delimiter] || ",")) if type == Array
      return Hash[param.split(options[:delimiter] || ",").map{|c| c.split(options[:separator] || ":")}] if type == Hash
      return (/(false|f|no|n|0)$/i === param.to_s ? false : (/(true|t|yes|y|1)$/i === param.to_s ? true : nil)) if type == TrueClass || type == FalseClass || type == Boolean
      return nil
    end

    def validate!(param, options)
      options.each do |key, value|
        case key
        when :required
          raise InvalidParameterError, "Parameter is required" if value && param.nil?
        when :blank
          raise InvalidParameterError, "Parameter cannot be blank" if !value && case param
              when String
                !(/\S/ === param)
              when Array, Hash
                param.empty?
              else
                param.nil?
            end
        when :is
          raise InvalidParameterError, "Parameter must be #{value}" unless value === param
        when :in, :within, :range
          raise InvalidParameterError, "Parameter must be within #{value}" unless param.nil? || case value
              when Range
                value.include?(param)
              else
                Array(value).include?(param)
              end
        when :min
          raise InvalidParameterError, "Parameter cannot be less than #{value}" unless param.nil? || value <= param
        when :max
          raise InvalidParameterError, "Parameter cannot be greater than #{value}" unless param.nil? || value >= param
        when :min_length
          raise InvalidParameterError, "Parameter cannot have length less than #{value}" unless param.nil? || value <= param.length
        when :max_length
          raise InvalidParameterError, "Parameter cannot have length greater than #{value}" unless param.nil? || value >= param.length
        end
      end
    end

    # ActiveSupport #present? and #blank? without patching Object
    def present?(object)
      !blank?(object)
    end

    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end
  end

  helpers Param
end
