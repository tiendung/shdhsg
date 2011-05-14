class Settings < Settingslogic
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env

  def self.pyramid_height
    Math.sqrt(2 * User.count).floor
  end
end
