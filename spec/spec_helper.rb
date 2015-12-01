require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
])
SimpleCov.start do
  add_filter '/spec/'
end

require 'timecop'
require 'unread'
require 'generators/unread/migration/templates/migration.rb'

require 'app/models/reader'
require 'app/models/different_reader'
require 'app/models/sti_reader'
require 'app/models/email'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #  config.order = 'random'

  config.before :each do
    clear_db
  end

  config.after :each do
    Timecop.return
  end

  config.after :suite do
    UnreadMigration.down
  end
end

if I18n.respond_to?(:enforce_available_locales=)
  I18n.enforce_available_locales = false
end

def setup_db
  configs = YAML.load_file('spec/database.yml')
  ActiveRecord::Base.configurations = configs

  db_name = ENV['DB'] || 'sqlite'

  puts "Testing with ActiveRecord #{ActiveRecord::VERSION::STRING} on #{db_name}"

  ActiveRecord::Base.establish_connection(db_name.to_sym)
  ActiveRecord::Base.default_timezone = :utc
  ActiveRecord::Migration.verbose = false

  UnreadMigration.up
  SpecMigration.up
end

def clear_db
  Reader.delete_all
  DifferentReader.delete_all
  StiReader.delete_all
  Email.delete_all
  ReadMark.delete_all
end

setup_db
