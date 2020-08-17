class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs do |t|
      t.string :service
      t.string :url
      t.string :company_name
      t.string :category
      t.string :title
      t.string :place
      t.integer :fee_min
      t.integer :fee_max
      t.json :skills
      t.string :product_proposal_level
      t.string :business_proposal_level
      t.string :people_management_level

      t.timestamps
    end
  end
end
