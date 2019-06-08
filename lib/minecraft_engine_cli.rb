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

  def list_backups(name = nil)
    backups = []
    result = @dropbox_api.list_folder ""
    files = result.entries
    
    files.each do |f|
      if f.is_a?(DropboxApi::Metadata::File)
        minecraft = "minecraft"
        if f.name.length > minecraft.length
          if f.name[0..minecraft.length-1] == minecraft
            if name != nil
              if f.name.split('-')[1] == name
                backups << "#{f.name}"
              end
            else
              backups << "#{f.name}"
            end
          end
        end
      end
    end
    backups
  end

  def count_backups(name = nil)
    backups = list_backups(name)
    backups.count
  end

  def last_backup(name)
    list_backups(name).last
  end

  def backup(name, ip)
    system "ssh -o StrictHostKeyChecking=no root@#{ip} \"ruby /backup.rb #{name}\""
  end

  def get_link(filename)
    link = @dropbox_api.get_temporary_link(filename)
  end

  def stop(name)
    server = show(name)
    puts server.name
    backup_count = new_backup_count = count_backups(name)
    if server.name.split('-')[1] == name
      puts backup(name, server.networks.v4[0].ip_address)
      puts server.id
      while new_backup_count <= backup_count
        new_backup_count = count_backups(name)
        sleep(5)
      end
      puts last_backup(name)
      puts "deleting server #{server.id}"
      delete(server.id)
    end
  end

  def delete(id)
    @droplet_kit.droplets.delete(id: id)
  end

  private

  def show(name)
    server = ""
    servers = list_servers
    servers.each do |s|
      if s.name.include?(name)
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
