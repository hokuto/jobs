class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :service
      t.string :key
      t.string :company_name
      t.string :category
      t.string :title
      t.string :place
      t.integer :pay_min
      t.integer :pay_max
      t.json :skills

      t.timestamps
    end
  end
end
