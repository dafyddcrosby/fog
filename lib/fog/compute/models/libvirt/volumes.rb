require 'fog/core/collection'
require 'fog/compute/models/libvirt/volume'

module Fog
  module Compute
    class Libvirt

      class Volumes < Fog::Collection

        model Fog::Compute::Libvirt::Volume

        def all(filter=nil)
          data=[]          
          if filter.nil?
            connection.list_storage_pools.each do |poolname|
              pool=connection.lookup_storage_pool_by_name(poolname)
              pool.list_volumes.each do |volumename|
                data << { :raw => pool.lookup_volume_by_name(volumename) }
              end
            end
          else
            volume=nil
            begin
              volume=self.get_by_name(filter[:name]) if filter.has_key?(:name)
              volume=self.get_by_key(filter[:key]) if filter.has_key?(:key)
              volume=self.get_by_path(filter[:path]) if filter.has_key?(:path)
            rescue ::Libvirt::RetrieveError
              return nil
            end
            data << { :raw => volume}
          end

          load(data)
        end

        def get(key)
          self.all(:key => key).first
        end

        
        # Retrieve the volume by name
        def get_by_name(name)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
            volume=pool.lookup_volume_by_name(name)
            unless volume.nil? 
              return volume
            end
          end          

          return nil
        end

        # Retrieve the volume by key
        def get_by_key(key)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
            volume=pool.lookup_volume_by_key(key)
            unless volume.nil? 
              return  volume
            end
          end          

          return nil
        end

        # Retrieve the volume by key
        def get_by_path(path)
          connection.list_storage_pools.each do |poolname|
            pool=connection.lookup_storage_pool_by_name(poolname)
            volume=pool.lookup_volume_by_key(path)
            unless volume.nil? 
              return volume
            end
          end          

          return nil
        end


      end

    end
  end
end
