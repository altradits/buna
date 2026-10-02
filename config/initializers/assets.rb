if Rails.application.config.respond_to?(:assets)
  Rails.application.config.assets.version = "1.0"
  Rails.application.config.assets.paths << Rails.root.join("app/assets/images")
  Rails.application.config.assets.paths << Rails.root.join("app/assets/stylesheets")
  Rails.application.config.assets.paths << Rails.root.join("app/javascript")
end
