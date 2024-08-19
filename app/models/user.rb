# frozen_string_literal: true

class User
    attr_accessor :username, :role
  
    def initialize(username, role)
      @username = username
      @role = role
    end
end


