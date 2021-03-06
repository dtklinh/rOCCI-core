module Occi
  module Core
    describe Entities do
      let(:entities){ Occi::Core::Entities.new }
      let(:entity1){ Occi::Core::Entity.new }
      let(:entity2){ Occi::Core::Entity.new 'http://example.org/test/schema#entity2' }
      let(:testaction){ Occi::Core::Action.new scheme='http://schemas.ogf.org/occi/core/entity/action#', term='testaction', title='testaction action' }

      context 'populating' do

        it 'is created empty' do
          expect(entities.count).to eq 0
        end
        it 'gets entity Nos. right, 1' do
          entities << entity1
          expect(entities.count).to eq 1
        end
        it 'gets entity Nos. right, 2' do
          entities << entity1
          entities << entity2
          expect(entities.count).to eq 2
        end
        it 'gets correctly-typed elements' do
          entities << entity1
          entities << entity2
          expect(entities.first).to be_an_instance_of(Occi::Core::Entity)
        end
      end

      context '#model' do
        it 'has no model by default' do
          expect(entities.model).to be nil
        end
        it 'can be assigned model' do
          modl = Occi::Model.new
          entities.model = modl
          expect(entities.model).to eql modl
        end
        it 'uses the assigned model for new members' do
          modl = Occi::Model.new
          entities.model = modl
          entities << entity1
          expect(entities.first.model).to eql modl
        end
        it 'uses the assigned model for existing members' do
          entities << entity1
          modl = Occi::Model.new
          entities.model = modl
          expect(entities.first.model).to eql modl
        end
        it 'does not use unassigned model' do
          modl = Occi::Model.new
          entities << entity1
          expect(entities.first.model).to_not eql modl
        end
      end

      context '#create' do
        it 'creates a new element' do
          entities.create
          expect(entities.first).to be_instance_of(Occi::Core::Entity)
        end
        it 'accepts argument' do
          entities.create 'http://example.com/testnamespace#test'
          expect(entities.first).to be_kind_of 'Com::Example::Testnamespace::Test'.constantize
        end
      end

      context '#join' do
        it 'joins elements correctly' #do
#          entities << entity1
#          entities << entity2
#          expect(entities.join('|')).to eq 'whatever'
#        end
      end

      context '#as_json' do
        it 'renders elements with various attributes' #do
#          entity2.actions << testaction
#          entities << entity1
#          entities << entity2
#          hash=Hashie::Mash.new
#          hash2=Hashie::Mash.new
#          hash['kind'] = 'http://schemas.ogf.org/occi/core#entity'
#          hash2['kind'] = 'http://schemas.ogf.org/occi/core#entity'
#          hash2['actions'] = testaction.as_json
#          set=Array.new
#          set << hash
#          set << hash2
#          expect(entities.as_json).to eql(set)
#        end
      end
    end
  end
end
