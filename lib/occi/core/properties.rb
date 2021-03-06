module Occi
  module Core
    class Properties

      include Occi::Helpers::Inspect
      include Occi::Helpers::Comparators::Properties

      attr_accessor :default, :type, :required, :mutable, :pattern, :description
      alias_method :required?, :required
      alias_method :mutable?, :mutable

      # @param [Hash] properties
      # @param [Hash] default
      def initialize(properties={})
        self.default = properties[:default]
        self.type = properties[:type] ||= 'string'
        self.required = properties[:required] ||= false
        self.mutable = properties[:mutable] ||= false
        self.pattern = properties[:pattern] ||= '.*'
        self.description = properties[:description]
      end

      def as_json(options={})
        hash = Hashie::Mash.new
        hash.default = self.default if self.default
        hash.type = self.type if self.type
        hash.required = self.required if self.required
        hash.mutable = self.mutable if self.mutable
        hash.pattern = self.pattern if self.pattern
        hash.description = self.description if self.description

        hash
      end

      # @return [Bool] Indicating whether this set of properties is "empty", i.e. no attributes are set
      def empty?
        as_json.empty?
      end

    end
  end
end
