require_relative 'EMS'

require 'yaml'
require 'sequel'
 
# Init Db
db_config_file = File.join(File.dirname(__FILE__), 'config', 'database.yml')
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
  Sequel.extension :migration
end

# Load controllers
Dir[File.join(File.dirname(__FILE__), 'app/controllers', '**', '*.rb')].sort.each {|file| require file }

# Load models
Dir[File.join(File.dirname(__FILE__), 'app/models', '**', '*.rb')].sort.each {|file| require file }



if DB
    Sequel::Migrator.run(DB, File.join(File.dirname(__FILE__), 'migrations'))
end
run EMS.router 