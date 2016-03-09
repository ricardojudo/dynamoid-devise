require 'rails/generators/named_base'
require 'generators/devise/orm_helpers'

module Dynamoid
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      include Devise::Generators::OrmHelpers

      def generate_model
        invoke "dynamoid:model", [name] unless model_exists? && behavior == :invoke
      end

      def inject_field_types
        inject_into_file model_path, migration_data, after: "include Dynamoid::Document\n" if model_exists?
      end

      def inject_devise_content
        inject_into_file model_path, model_contents, after: "include Dynamoid::Document\n" if model_exists?
      end

      def migration_data
<<RUBY
          ## Database authenticatable
          field :email
          field :encrypted_password

          ## Recoverable
          field :reset_password_token
          field :reset_password_sent_at, :dateime

          ## Rememberable
          field :remember_created_at, :dateime

          ## Trackable
          field :sign_in_count, :integer
          field :current_sign_in_at, :dateime
          field :last_sign_in_at, :dateime
          field :current_sign_in_ip
          field :last_sign_in_ip

          ## Confirmable
          # field :confirmation_token
          # field :confirmed_at, :dateime
          # field :confirmation_sent_at, :dateime
          # field :unconfirmed_email# Only if using reconfirmable

          ## Lockable
          # field :failed_attempts, :integer # Only if lock strategy is :failed_attempts
          # field :unlock_token # Only if unlock strategy is :email or :both
          # field :locked_at, :dateime
RUBY
      end
    end
  end
end
