class UserSession < Authlogic::Session::Base
  # required by authlogic to work with rails 3
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end

  def self.login_offline_user
    raise "Cannot login as offline user unless offline mode" if Mode.online?
    UserSession.new(:email => User::OFFLINE_USER_EMAIL,
      :password => User::OFFLINE_USER_PASSWORD)
  end
end
