namespace :friendly_extensions do

  desc "copy gems from database to yaml file"
  task :migrate_old_labels => :environment do

    labels_hash = { 'labels' => {}, 'label_tooltips' => {}}

    FriendsLabel.all.each do |label|
      labels_hash['labels'].merge!(label.attribute_name => label.label)
      labels_hash['label_tooltips'].merge!(label.attribute_name => label.tooltip) unless label.tooltip.blank?
    end

    yaml_hash = {I18n.default_locale.to_s => { 'friendly_labels' => labels_hash } }

    yaml_output_path = "#{Rails.root}/config/locales/friendly_labels.#{I18n.default_locale}.yml"

    File.open(yaml_output_path, 'wb+') do |f|
      f.puts YAML::dump(yaml_hash)
      f.close
    end
  end
end