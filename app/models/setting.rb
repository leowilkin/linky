class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true

  def self.allowed_domains
    domains_setting = find_by(key: 'allowed_domains')
    return [] unless domains_setting
    domains_setting.value.split("\n").map(&:strip).reject(&:blank?)
  end

  def self.allowed_domains=(domains_array)
    domains_setting = find_or_initialize_by(key: 'allowed_domains')
    domains_setting.value = domains_array.join("\n")
    domains_setting.save
  end
end
