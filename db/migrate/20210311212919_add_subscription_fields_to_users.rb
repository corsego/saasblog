class AddSubscriptionFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :plan, :string
    add_column :users, :subscription_status, :string, default: "incomplete"
  end
end
