require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'active_record/railtie'
Bundler.require(:default, Rails.env)

module TAS
  class Application < Rails::Application
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    config.assets.initialize_on_precompile = false
  end
end
