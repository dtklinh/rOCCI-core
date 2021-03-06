module Occi
  class Model < Occi::Collection

    # @param [Occi::Core::Collection] collection
    def initialize(collection=nil)
      super(nil, nil) # model must be empty for model class
      register_core
      register_collection collection if collection.kind_of? Occi::Collection
    end

    def model=(model)
      # will not assign a model inside a model
    end

    # register Occi Core categories enitity, resource and link
    def register_core
      Occi::Log.info "[#{self.class}] Registering OCCI Core categories enitity, resource and link"
      register Occi::Core::Entity.kind
      register Occi::Core::Resource.kind
      register Occi::Core::Link.kind
    end

    # register Occi Infrastructure categories
    def register_infrastructure
      Occi::Log.info "[#{self.class}] Registering OCCI Infrastructure categories"
      Occi::Infrastructure.categories.each { |category| register category }
    end

    # register OCCI categories from files
    #
    # @param [String] path to a folder containing files which include OCCI collections in JSON format. The path is
    #  recursively searched for files with the extension .json .
    # @param [Sting] scheme_base_url base location for provider specific extensions of the OCCI model
    def register_files(path, scheme_base_url='http://localhost')
      Occi::Log.info "[#{self.class}] Initializing OCCI Model from #{path}"
      Dir.glob(path + '/**/*.json').each do |file|
        collection = Occi::Collection.new(JSON.parse(File.read(file)))
        # add location of service provider to scheme if it has a relative location
        collection.kinds.collect { |kind| kind.scheme = scheme_base_url + kind.scheme if kind.scheme.start_with? '/' } if collection.kinds
        collection.mixins.collect { |mixin| mixin.scheme = scheme_base_url + mixin.scheme if mixin.scheme.start_with? '/' } if collection.mixins
        collection.actions.collect { |action| action.scheme = scheme_base_url + action.scheme if action.scheme.start_with? '/' } if collection.actions
        register_collection collection
      end
    end

    # register OCCI categories from OCCI collection
    def register_collection(collection)
      collection.kinds.each { |kind| kind.model = self }
      collection.mixins.each { |mixin| mixin.model = self }
      collection.actions.each { |action| action.model = self }
      merge! collection
    end

    # clear all entities from all categories
    def reset()
      categories.each { |category| category.entities = [] if category.respond_to? :entities }
    end

    # @param [Occi::Core::Category] category
    def register(category)
      Occi::Log.debug "[#{self.class}] Registering category #{category}"
      # add model to category as back reference
      category.model = self
      @kinds << category unless get_by_id(category.to_s) if category.class.ancestors.include? Occi::Core::Kind
      @mixins << category unless get_by_id(category.to_s) if category.class.ancestors.include? Occi::Core::Mixin
      @actions << category unless get_by_id(category.to_s) if category.class.ancestors.include? Occi::Core::Action
    end

    # @param [Occi::Core::Category] category
    def unregister(category)
      Occi::Log.debug "[#{self.class}] Unregistering category #{category.type_identifier}"
      @kinds.delete category
      @mixins.delete category
      @actions.delete category
    end

    # Return all categories from model. If filter is present, return only the categories specified by filter
    #
    # @param [Occi::Collection,Occi::Core::Category,String] filter
    # @return [Occi::Collection] collection
    def get(filter = nil)
      (filter && !filter.empty? ) ? self.get_related_to(filter) : self
    end

  end
end