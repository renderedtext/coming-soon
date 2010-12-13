namespace :db do
  task :environment do
    require 'active_record'
    require 'logger'

    DB_CONFIG = YAML.load_file("database.yml")

    ActiveRecord::Base.establish_connection(
      :adapter  => DB_CONFIG['adapter'],
      :host     => DB_CONFIG['host'],
      :username => DB_CONFIG['username'],
      :password => DB_CONFIG['password'],
      :database => DB_CONFIG['name']
    )
  end

  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end
