class Loan
    attr_accessor :admin_username, :customer_username, :principal, :rate, :tenure, :total_amount, :emi, :remaining_emis
  
    def initialize(admin_username:, customer_username:, principal:, rate:, start_date: Date.today, tenure:)
        @admin_username = admin_username
        @customer_username = customer_username
        @principal = principal.to_f
        @rate = rate.to_f
        @tenure = tenure.to_i
        @paid_emis = 0
        @start_date = start_date
        calculate_loan_details
    end
  
    def calculate_loan_details
        interest = (@principal * @tenure * @rate) / 100
        @total_amount = @principal + interest
        @emi = @total_amount / (@tenure * 12)
        @remaining_emis = @tenure * 12
    end
  
    def make_payment
        if @remaining_emis > 0
          @paid_emis += 1
          @remaining_emis -= 1 
        end
      end

    def payment_schedule
        schedule = []
        current_date = @start_date

        1.upto(@tenure * 12) do |emi_number|
        status = emi_number <= @paid_emis ? 'Paid' : 'Pending'
        
        schedule << {
            emi_number: emi_number,
            emi_amount: @emi.round(2),
            payment_due_date: current_date.strftime('%Y-%m-%d'),
            status: status
        }

        current_date = current_date >> 1 # Move to the next month
        end

        schedule
      end
end