class AddAttToPatients < ActiveRecord::Migration[5.1]
  def change
    add_column :patients, :national_id, :string
    add_column :patients, :phone_number, :string
    add_column :patients, :age, :integer
    add_column :patients, :fname, :string
    add_column :patients, :lname, :string
    add_column :patients, :city, :string
    add_column :patients, :street, :string
    add_column :patients, :gender, :string
  end
end
