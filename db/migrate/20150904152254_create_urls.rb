class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.string :shortened_path, index: :true
      t.belongs_to :user
      t.timestamps null: false
    end
  end
end
