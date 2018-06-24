class CreateRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :records do |t|
      t.string :national_id
      t.string :diagnosist
      
      t.timestamps
    end
  end
end
