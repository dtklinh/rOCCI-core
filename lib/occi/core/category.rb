module Occi
  module Core
    class Category

      include Occi::Helpers::Inspect
      include Occi::Helpers::Comparators::Category

      attr_accessor :scheme, :term, :title, :attributes, :model

      # @param scheme [String] The categorisation scheme.
      # @param term [String] Unique identifier of the Category instance within the categorisation scheme.
      # @param title [String] The display name of an instance.
      # @param attributes [Occi::Core::Attributes,Hash] Set of Attribute instances.
      def initialize(scheme='http://schemas.ogf.org/occi/core#',
          term='category',
          title=nil,
          attributes=Occi::Core::Attributes.new)
        raise ArgumentError, 'scheme and term cannot be nil' unless scheme && term
        raise ArgumentError, 'scheme and term cannot be empty' if scheme.empty? || term.empty?
        attributes ||= Occi::Core::Attributes.new

        scheme << '#' unless scheme.end_with? '#'
        @scheme = scheme
        @term = term
        @title = title

        case attributes
          when Occi::Core::Attributes
            @attributes = attributes
          else
            @attributes = Occi::Core::Attributes.parse attributes
        end
      end

      # @return [String] Type identifier of the Category.
      def type_identifier
        "#{self.scheme}#{self.term}"
      end

      # @param options [Hash]
      # @return [Hashie::Mash] JSON representation of Category.
      def as_json(options={})
        category = Hashie::Mash.new
        category.scheme = self.scheme
        category.term = self.term
        category.title = self.title if self.title
        category.attributes = self.attributes.as_json if self.attributes.any?
        category
      end

      # @return [String] Short text representation of the Category.
      def to_string_short
        "#{self.term};scheme=#{self.scheme.inspect};class=#{self.class.name.demodulize.downcase.inspect}"
      end

      # @return [String] Full text representation of the Category.
      def to_string
        string = self.to_string_short
        string << ";title=#{self.title.inspect}" if self.title
        string
      end

      # @return [String] Text representation of the Category.
      def to_text
        "Category: #{self.to_string}"
      end

      # @return [Hash] Hash containing the HTTP headers of the text/occi rendering.
      def to_header
        {:Category => self.to_string}
      end

      # @return [NilClass] Returns nil as Category itself does not have a location.
      def location
        nil # not implemented
      end

      # @return [String] Type Identififier of the Category.
      def to_s
        self.type_identifier
      end

      # @return [Bool] Indicating whether this category is "empty", i.e. required attributes are blank
      def empty?
        term.blank? || scheme.blank?
      end

      # @param term [String] Term to check.
      # @return [Bool] Indicating whether term consists exclusively of valid characters.
      def self.valid_term?(term)
        term =~ /^[a-z][a-z0-9_-]*$/
      end

    end
  end
end
