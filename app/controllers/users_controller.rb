class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

    def create
        username = params[:username]
        role = params[:role]
    
        if $users[username]
          render json: { error: 'User already exists' }, status: :bad_request
        else
          $users[username] = User.new(username, role)
          render json: { message: 'User created successfully' },status: :created
        end
    end
end
