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
    @droplet_kit.droplets.all(tag_name: 'minecraft')
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

  private

  def show(name)
    server = ""
    servers = list_servers
    list = servers.split("\n")
    list.each do |s|
      if s.include?(name)
        server = s
      end
    end
    server
  end

  def property(property_string)
    property_string.split(" ")[1]
  end

  def server_properties(server_string)
    parts = server_string.split(",")
    id = property(parts[0])
    name = property(parts[1])
    ip = property(parts[2])
    {id: id, name: name, ip: ip}
  end

end
