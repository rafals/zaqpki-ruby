class Message < ActiveRecord::Base
  def read
    self.is_read = true
  end
end
