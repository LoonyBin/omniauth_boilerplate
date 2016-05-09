require 'rails/generators/base'
require 'rails/generators/active_record'

module OmniauthBoilerplate
  # ```sh
  # $ rails generate omniauth_boilerplate:install
  # ```
  #
  # The omniauth-boilerplate install generator:
  #
  # * Inserts `OmniauthBoilerplate::User` into your `User` model
  # * Inserts `OmniauthBoilerplate::Controller` into your `ApplicationController`
  # * Mounts the engine at `/auth`
  # * Creates an initializer file to allow further configuration.
  # * Creates a migration file that creates an authentications table
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    desc 'Install boilerplate code for omniauth'
    source_root File.expand_path('../templates', __FILE__)

    def create_omniauth_initializer
      copy_file 'omniauth.rb', 'config/initializers/omniauth.rb'
    end

    def inject_omniauth_boilerplate_into_application_controller
      inject_into_class(
        'app/controllers/application_controller.rb',
        ApplicationController,
        "  include OmniauthBoilerplate::Controller\n"
      )
    end

    def mount_omniauth_boilerplate_engine_at_auth
      route "mount OmniauthBoilerplate::Engine => '/auth'"
    end

    def create_or_inject_omniauth_boilerplate_into_user_model
      if File.exist? 'app/models/user.rb'
        inject_into_class(
          'app/models/user.rb',
          User,
          "  include OmniauthBoilerplate::User\n\n",
        )
      else
        @inherit_from = models_inherit_from
        template('user.rb.erb', 'app/models/user.rb')
      end
    end

    def create_omniauth_boilerplate_migration
      create_migration_if_required_for(:users)
      create_migration_if_required_for(:omniauth_boilerplate_authentications)

    end

    def display_readme_in_terminal
      readme 'README'
    end

    # for generating a timestamp when using `create_migration`
    def self.next_migration_number(dir)
      ActiveRecord::Generators::Base.next_migration_number(dir)
    end

    private

    def create_migration_if_required_for(table_name)
      return if table_exists? table_name
      copy_migration "create_#{table_name}.rb"
    end

    def copy_migration(migration_name, config = {})
      unless migration_exists?(migration_name)
        migration_template(
          "db/migrate/#{migration_name}.erb",
          "db/migrate/#{migration_name}",
          config.merge(migration_version: migration_version)
        )
      end
    end

    def migration_exists?(name)
      existing_migrations.include?(name)
    end

    def existing_migrations
      @existing_migrations ||= Dir.glob('db/migrate/*.rb').map do |file|
        migration_name_without_timestamp(file)
      end
    end

    def migration_name_without_timestamp(file)
      file.sub(%r{^.*(db/migrate/)(?:\d+_)?}, '')
    end

    def table_exists?(table_name)
      if ActiveRecord::Base.connection.respond_to?(:data_source_exists?)
        ActiveRecord::Base.connection.data_source_exists?(table_name)
      else
        ActiveRecord::Base.connection.table_exists?(table_name)
      end
    end

    def migration_version
      return unless Rails.version >= '5.0.0'
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
    end

    def models_inherit_from
      if Rails.version >= '5.0.0'
        'ApplicationRecord'
      else
        'ActiveRecord::Base'
      end
    end
  end
end
