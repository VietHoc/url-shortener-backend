class Url < ApplicationRecord
  validates :original_url, presence: true, format: URI::regexp(%w[http https])
  validates :short_url, presence: true, uniqueness: true

  before_validation :generate_short_url

  private

  def generate_short_url
    self.short_url = SecureRandom.urlsafe_base64(4, false)
  end
end
