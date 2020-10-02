# frozen_string_literal: true

module Sinatra
  module Param
    # A wrapper/delegator to an uploaded file.
    #
    # The attributes are the same as the original parameter hash keys with
    # extra aliases conforming to the `Rack::Multipart::UploadedFile` interface.
    class UploadedFile < SimpleDelegator
      attr_reader :filename, :head, :name, :tempfile, :type

      def initialize(filename:, head:, name:, tempfile:, type:)
        super(tempfile)
        @filename = filename
        @head = head
        @name = name
        @tempfile = tempfile
        @type = type
      end

      alias content_type type
      alias original_filename filename

      def self.from_param(param)
        new(
          filename: param.fetch(:filename),
          head: param.fetch(:head),
          name: param.fetch(:name),
          tempfile: param.fetch(:tempfile),
          type: param.fetch(:type),
        )
      rescue KeyError, NoMethodError => e
        raise ArgumentError, e.message
      end
    end
  end
end
