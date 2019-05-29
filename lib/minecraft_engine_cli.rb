require 'droplet_kit'
require 'dropbox_api'
require 'yaml'

class MinecraftEngineCLI
  def initialize
    @config = YAML.load_file(File.join(Dir.home, '.minecraft_engine_cli.yml'))
    @droplet_kit = DropletKit::Client.new(access_token: @config['digital_ocean_api_key'])
    @dropbox_api = DropboxApi::Client.new(@config['dropbox_api_key'])
  end

  def start
    puts "Hello World"
  end

  def list_servers
    droplets = @droplet_kit.droplets.all(tag_name: 'minecraft')
    droplets.each do |d|
      puts "id: #{d.id}, name: #{d.name}, ip: #{d.networks.v4[0].ip_address}"
    end
  end

  def list_backups
    result = @dropbox_api.list_folder ""
    files = result.entries
    
    files.each do |f|
      if f.is_a?(DropboxApi::Metadata::File)
        minecraft = "minecraft"
        if f.name.length > minecraft.length
          if f.name[0..minecraft.length-1] == minecraft
            puts "#{f.name}"
          end
        end
      end
    end
  end

  def get_link(filename)
    link = @dropbox_api.get_temporary_link(filename)
  end
end
