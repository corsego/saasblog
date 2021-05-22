class AddCurrentPeriodEndToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :current_period_end, :datetime
  end
end
