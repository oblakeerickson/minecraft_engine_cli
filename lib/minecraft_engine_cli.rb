require 'droplet_kit'
require 'yaml'

class MinecraftEngineCLI
  def initialize
    @config = YAML.load_file(File.join(Dir.home, '.minecraft_engine_cli.yml'))
    @droplet_kit = DropletKit::Client.new(access_token: @config['digital_ocean_api_key'])
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
end
