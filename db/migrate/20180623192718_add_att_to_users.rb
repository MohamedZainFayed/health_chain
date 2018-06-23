class AddAttToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :national_id, :string
    add_column :users, :phone_number, :string
    add_column :users, :age, :integer
    add_column :users, :fname, :string
    add_column :users, :lname, :string
    add_column :users, :city, :string
    add_column :users, :street, :string
    add_column :users, :department, :string
  end
end
