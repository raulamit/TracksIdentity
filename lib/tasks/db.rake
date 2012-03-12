require 'active_record/fixtures'
require 'find'

REF_DATA_PATH = Rails.root.to_s + "/db/seed/ref_data"

namespace :db do

  #preload models
  task :load_decode => :environment do
    # relative path assumes this is defined in a file in lib/tasks
    Dir[File.dirname(__FILE__) + '/../../app/models/ref_decode.rb'].each do |file|
      puts "Loading Model: " + file
      require file
    end
  end

  desc "Seed the database with before_others/ fixtures."
  task :ref_refresh => [:environment] do
    load_fixtures "seed/before_others", :always
  end

  desc "Raise an error unless the Rails.env is development"
  task :development_environment_only do
    raise "Hey, development only, you monkey!" unless Rails.env.development?
  end

  desc "Refresh Database, drop, create and migrate."
  task :refresh => [:environment, :development_environment_only, :drop, :create, :migrate, :ref_refresh, :seed]

  desc "Refresh Database, drop, create and migrate."
  task :refresh_schema => [:environment, :development_environment_only, :drop, :create, 'schema:load', :ref_refresh, :seed]

  private

  def load_fixtures(dir, always = false)
    Dir.glob(File.join(Rails.root.to_s, 'db', dir, '*.yml')).each do |fixture_file|
      puts "File: " + fixture_file
      table_name = File.basename(fixture_file, '.yml')

      if table_empty?(table_name) || always
        truncate_table(table_name)
        ActiveRecord::Fixtures.create_fixtures(File.join('db/', dir), table_name)
      end
    end
  end

  def table_empty?(table_name)
    quoted = connection.quote_table_name(table_name)
    connection.select_value("SELECT COUNT(*) FROM #{quoted}").to_i.zero?
  end

  def truncate_table(table_name)
    quoted = connection.quote_table_name(table_name)
    connection.execute("DELETE FROM #{quoted}")
  end

  def connection
    ActiveRecord::Base.connection
  end

  def tablify_string( string )
    eval( string.to_s.gsub( /_id/, '' ).singularize.split( '_' ).collect { |word| word.capitalize }.join )
  end
end