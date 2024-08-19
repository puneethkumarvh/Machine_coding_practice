class LoansController < ApplicationController
    skip_before_action :verify_authenticity_token
    # before_action :validate_user

  def create
    admin_username = params[:admin_username]
    customer_username = params[:customer_username]
    principal = params[:principal]
    rate = params[:rate]
    tenure = params[:tenure]

    if $users[admin_username]&.role != 'admin'
      render json: { error: 'Invalid admin' }, status: :forbidden
    elsif $users[customer_username]&.role != 'customer'
      render json: { error: 'Invalid customer' }, status: :forbidden
    else
      loan = Loan.new(admin_username: admin_username, customer_username: customer_username, principal: principal, rate: rate, tenure: tenure)
      $loans << loan
      render json: { message: 'Loan created successfully', loan: loan }
    end
  end

  def show
    customer_username = params[:customer_username]
    loans = $loans.select { |loan| loan.customer_username == customer_username }
    
    if loans.empty?
      render json: { error: 'No loans found' }, status: :not_found
    else
      render json: loans
    end
  end

  def make_payment
    loan = $loans.find { |loan| loan.customer_username == params[:customer_username] }

    if loan.nil?
      render json: { error: 'Loan not found' }, status: :not_found
    elsif loan.remaining_emis <= 0
      render json: { message: 'All EMIs have been paid' }
    else
      loan.make_payment
      render json: { message: 'Payment made successfully', remaining_emis: loan.remaining_emis }
    end
  end

  def all_loans
    render json: $loans
  end

  def payment_schedule
    customer_username = params[:customer_username]
    loans = $loans.select { |loan| loan.customer_username == customer_username }

    if loans.empty?
      render json: { error: 'No loans found' }, status: :not_found
    else
      schedule = loans.flat_map(&:payment_schedule)
      render json: schedule
    end
  end

  private

  def validate_user
    byebug
    unless $users[params[:username]]
      render json: { error: 'Invalid user' }, status: :forbidden
    end
  end
end
