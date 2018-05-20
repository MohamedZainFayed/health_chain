class AddTfaCipherToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :tfa_cipher, :string
  end
end
