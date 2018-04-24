CONFIG_PATH = "#{Rails.root}/config/config.yml"

APP_CONFIG = YAML.load_file(CONFIG_PATH)[Rails.env]

$redis = Redis::Namespace.new("little_weather", redis: Redis.new)
