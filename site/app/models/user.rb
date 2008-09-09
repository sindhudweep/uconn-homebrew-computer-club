require 'digest/sha2'
class User < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def password=(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m" ).chomp
    self.salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
  def self.authenticate(email, password)
    user = User.find(:first, :conditions => ['email_address = ?' , email])
    if user.blank? ||
      Digest::SHA256.hexdigest(password + user.salt) != user.password_hash
      raise "Username or password invalid"
    end
    user
  end
end
