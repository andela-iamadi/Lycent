class CreateHits < ActiveRecord::Migration
  def change
    create_table :hits do |t|
      t.string :ip_address
      t.string :referrer
      t.belongs_to :url
      t.timestamps null: false
    end
  end
end
