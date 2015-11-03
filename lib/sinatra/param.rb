require 'sinatra/base'
require 'sinatra/param/version'
require 'date'
require 'time'

module Sinatra
  module Param
    Boolean = :boolean

    class InvalidParameterError < StandardError
      attr_accessor :param, :options
    end

    def param(name, type, options = {})
      name = name.to_s
      applicable_params = @applicable_params || params

      return unless applicable_params.member?(name) or options[:default] or options[:required]

      begin
        applicable_params[name] = coerce(applicable_params[name], type, options)
        applicable_params[name] = (options[:default].call if options[:default].respond_to?(:call)) || options[:default] if applicable_params[name].nil? and options[:default]
        applicable_params[name] = options[:transform].to_proc.call(applicable_params[name]) if applicable_params[name] and options[:transform]
        validate!(applicable_params[name], options)


        if block_given?
          if type != Hash
            raise Sinatra::Param::InvalidParameterError.new(
              'Only the Hash parameter validation can use sub hash validation method')
          end
          original_applicable_params = @applicable_params
          original_parent_key_name = @parent_key_name
          @applicable_params = applicable_params[name]
          @parent_key_name = formatted_params(@parent_key_name, name)

          yield

          @applicable_params = original_applicable_params
          @parent_key_name = original_parent_key_name
        end
      rescue InvalidParameterError => exception
        exception_name = formatted_params(@parent_key_name, name)
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param = exception_name
          exception.options = options
          raise exception
        end

        error = exception.to_s

        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {exception_name => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    def one_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)
      applicable_params = @applicable_params || params

      return unless names.length >= 2

      begin
        validate_one_of!(applicable_params, names, options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = names, options
          raise exception
        end

        error = "Invalid parameters #{formatted_params(@parent_key_name, names)}"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {names => exception.message}}.to_json
        end

        halt 400, error
      end
    end

    def any_of(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      names = args.collect(&:to_s)
      applicable_params = @applicable_params || params

      return unless names.length >= 2

      begin
        validate_any_of!(applicable_params, names, options)
      rescue InvalidParameterError => exception
        if options[:raise] or (settings.raise_sinatra_param_exceptions rescue false)
          exception.param, exception.options = names, options
          raise exception
        end

        formatted_params = formatted_params(@parent_key_name, names)
        error = "Invalid parameters #{formatted_params}"
        if content_type and content_type.match(mime_type(:json))
          error = {message: error, errors: {formatted_params => exception.message}}.to_json
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
      if names.count{|name| present?(params[name])} > 1
        raise InvalidParameterError, "Only one of #{formatted_params(@parent_key_name, names)} is allowed"
      end
    end

    def validate_any_of!(params, names, options)
      if names.count{|name| present?(params[name])} < 1
        raise InvalidParameterError, "One of parameters #{formatted_params(@parent_key_name, names)} is required"
      end
    end

    # ActiveSupport #present? and #blank? without patching Object
    def present?(object)
      !blank?(object)
    end

    def blank?(object)
      object.respond_to?(:empty?) ? object.empty? : !object
    end

    def formatted_params(parent_key, name)
      if name.is_a?(Array)
        name = "[#{name.join(', ')}]"
      end

      return parent_key ? "#{parent_key}[#{name}]" : name
    end
  end

  helpers Param
end
