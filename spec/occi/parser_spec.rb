module Occi
  describe "Parser" do

    it "parses an OCCI message with MIME type text/plain containing an OCCI resource" do
      # create new collection
      collection = Occi::Collection.new
      # create new resource within collection
      resource = collection.resources.create

      # render collection to text/plain MIME type
      rendered_collection = collection.to_text
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/plain', rendered_collection).to_json.should == collection.to_json

      # add attributes to resource
      resource.id = UUIDTools::UUID.random_create.to_s
      resource.title = 'title'

      # render collection to text/plain MIME type
      rendered_collection = collection.to_text
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/plain', rendered_collection).to_json.should == collection.to_json

      # add mixin to resource
      resource.mixins << Occi::Core::Mixin.new

      # render collection to text/plain MIME type
      rendered_collection = collection.to_text
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/plain', rendered_collection).to_json.should == collection.to_json

      # add link to resource
      link = resource.links.create
      link.id = UUIDTools::UUID.random_create.to_s
      link.target = 'http://example.com/resource/aee5acf5-71de-40b0-bd1c-2284658bfd0e'
      link.source = resource
      collection << link

      # render collection to text/plain MIME type
      rendered_collection = collection.to_text
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/plain', rendered_collection).to_json.should == collection.to_json
    end

    it "parses an OCCI message with MIME type text/occi containing an OCCI resource" do
      # create new collection
      collection = Occi::Collection.new
      # create new resource within collection
      resource = collection.resources.create

      # render collection to text/occi MIME type
      rendered_collection = collection.to_header
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/occi', '', false, Occi::Core::Resource, rendered_collection).to_header.should == collection.to_header

      # add attributes to resource
      resource.id = UUIDTools::UUID.random_create.to_s
      resource.title = 'title'

      # render collection to text/occi MIME type
      rendered_collection = collection.to_header
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/occi', '', false, Occi::Core::Resource, rendered_collection).to_header.should == collection.to_header

      # add mixin to resource
      resource.mixins << Occi::Core::Mixin.new

      # render collection to text/occi MIME type
      rendered_collection = collection.to_header
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/occi', '', false, Occi::Core::Resource, rendered_collection).to_header.should == collection.to_header

      # add link to resource
      link = resource.links.create
      link.id = UUIDTools::UUID.random_create.to_s
      link.target = 'http://example.com/resource/aee5acf5-71de-40b0-bd1c-2284658bfd0e'
      link.source = resource
      collection << link

      # render collection to text/occi MIME type
      rendered_collection = collection.to_header
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('text/occi', '', false, Occi::Core::Resource, rendered_collection).to_header.should == collection.to_header
    end

    it "parses an OCCI message with MIME type application/occi+json containing an OCCI resource" do
      # create new collection
      collection = Occi::Collection.new
      # create new resource within collection
      resource = collection.resources.create

      # render collection to text/plain MIME type
      rendered_collection = collection.to_json
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('application/occi+json', rendered_collection).should == collection

      # add attributes to resource
      resource.id = UUIDTools::UUID.random_create.to_s
      resource.title = 'title'

      # render collection to text/plain MIME type
      rendered_collection = collection.to_json
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('application/occi+json', rendered_collection).should == collection

      # add mixin to resource
      resource.mixins << Occi::Core::Mixin.new

      # render collection to text/plain MIME type
      rendered_collection = collection.to_json
      # parse rendered collection and compare with original collection
      Occi::Parser.parse('application/occi+json', rendered_collection).should == collection

      # add link to resource
      link = resource.links.create
      link.target = '/resource/aee5acf5-71de-40b0-bd1c-2284658bfd0e'
      link.source = resource.location

      # render collection to text/plain MIME type
      rendered_collection = collection.to_json
      # parse rendered collection and compare with original collection
      # TODO: Temporarily deactivating
#      Occi::Parser.parse('application/occi+json', rendered_collection).should == collection
    end

    it "parses an OVF file" do
      media_type = 'application/ovf+xml'
      body = File.read('spec/occi/test.ovf')
      collection = Occi::Parser.parse(media_type, body)
      storage_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
      storage_resources.should have(1).storage_resource
      storage_resources.first.title.should == 'lamp'
      network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
      network_resources.should have(1).network_resource
      network_resources.first.title.should == 'VM Network'
      compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
      compute_resources.should have(1).compute_resource
      compute_resources.first.attributes.occi!.compute!.cores.should == 1
      compute_resources.first.attributes.occi!.compute!.memory.should == 0.25
    end

    it "parses an OVA container" do
      media_type = 'application/ova'
      body = File.read('spec/occi/test.ova')
      collection = Occi::Parser.parse(media_type, body)
      storage_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
      storage_resources.should have(1).storage_resource
      storage_resources.first.title.should == 'lamp'
      network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
      network_resources.should have(1).network_resource
      network_resources.first.title.should == 'VM Network'
      compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
      compute_resources.should have(1).compute_resource
      compute_resources.first.attributes.occi!.compute!.cores.should == 1
      compute_resources.first.attributes.occi!.compute!.memory.should == 0.25
    end

#    ZS 11 Oct 2013: XML format not yet properly specified
#    it "parses a XML file" do
#      media_type = 'application/xml'
#      body = File.read('spec/occi/test.xml')
#      collection = Occi::Parser.parse(media_type, body)
#      
#    end

  end
end
