require 'digest/md5'

class ActivationKey < ActiveRecord::Base
  OFFLINE_PRICE = 395

  validates :comment, :presence => true

  def self.get_key(email, password)
    digest = Digest::MD5.hexdigest(email + password)
    digest[22,32].upcase
  end

  def self.valid?(email, password, activation_key)
    get_key(email, password) == activation_key.upcase
  end

  def self.activated?
    Mode.online? or ActivationKey.count > 0
  end
end
