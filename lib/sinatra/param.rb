require 'sinatra/base'
require 'sinatra/param/version'
require 'date'
require 'time'

module Sinatra
  module Param
    Boolean = :boolean
    EMBEEDED_HASH_MATCH = /^([^\[\]]+)\[(.+)\]$/

    class InvalidParameterError < StandardError
      attr_accessor :param, :options
    end

    def param(name, type, options = {})
      name = name.to_s

      if embedded_param?(name)
        embed = embedded_param_keys(name)

        param_exists = params.member?(embed[:key]) && params[embed[:key]].member?(embed[:embedded_key])

        get_param = Proc.new{params[embed[:key]][embed[:embedded_key]] if params[embed[:key]]}
        set_param = Proc.new do |value|
          if params[embed[:key]]
            params[embed[:key]][embed[:embedded_key]] = value
          else
            params[embed[:key]] = {embed[:embedded_key] => value}
          end
        end

      else
        param_exists = params.member?(name)
        
        get_param = Proc.new{params[name]}
        set_param = Proc.new{|value| params[name] = value}
        
        
      end

      return unless param_exists or options[:default] or options[:required]



      begin
        set_param.call coerce(get_param.call, type, options)
        set_param.call((options[:default].call if options[:default].respond_to?(:call)) || options[:default]) if get_param.call.nil? and options[:default]
        set_param.call options[:transform].to_proc.call(get_param.call) if get_param.call and options[:transform]
        validate!(get_param.call, options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = name, options
          raise exception
        end

        error = exception.to_s

        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {name => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    def one_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)

      return unless names.length >= 2

      begin
        validate_one_of!(params, names, options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = names, options
          raise exception
        end

        error = "Invalid parameters [#{names.join(', ')}]"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {names => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    def any_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)

      return unless names.length >= 2

      begin
        validate_any_of!(params, names, options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = names, options
          raise exception
        end

        error = "Invalid parameters [#{names.join(', ')}]"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {names => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    private

    def coerce(param, type, options = {})
      begin
        return nil if param.nil?
        return param if (param.is_a?(type) rescue false)
        return Integer(param) if type == Integer
        return Float(param) if type == Float
        return String(param) if type == String
        return Date.parse(param) if type == Date
        return Time.parse(param) if type == Time
        return DateTime.parse(param) if type == DateTime
        return Array(param.split(options[:delimiter] || ",")) if type == Array
        return Hash[param.split(options[:delimiter] || ",").map{|c| c.split(options[:separator] || ":")}] if type == Hash
        return (/(false|f|no|n|0)$/i === param.to_s ? false : (/(true|t|yes|y|1)$/i === param.to_s ? true : nil)) if type == TrueClass || type == FalseClass || type == Boolean
        return nil
      rescue ArgumentError
        raise InvalidParameterError, "'#{param}' is not a valid #{type}"
      end
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
        when :format
          raise InvalidParameterError, "Parameter must be a string if using the format validation" unless param.kind_of?(String)
          raise InvalidParameterError, "Parameter must match format #{value}" unless param =~ value
        when :is
          raise InvalidParameterError, "Parameter must be #{value}" unless param === value
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

    def validate_one_of!(params, names, options)
      raise InvalidParameterError, "Only one of [#{names.join(', ')}] is allowed" if names.count{|name| present?(params[name])} > 1
    end

    def validate_any_of!(params, names, options)
      raise InvalidParameterError, "One of parameters [#{names.join(', ')}] is required" if names.count{|name| present?(params[name])} < 1
    end

    # ActiveSupport #present? and #blank? without patching Object
    def present?(object)
      !blank?(object)
    end

    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end

    def embedded_param?(name)
      !!name.to_s.match(EMBEEDED_HASH_MATCH)
    end

    def embedded_param_keys(name)
      match = name.to_s.match(EMBEEDED_HASH_MATCH)
      {key: match[1], embedded_key: match[2]}
    end

  end

  helpers Param
end
