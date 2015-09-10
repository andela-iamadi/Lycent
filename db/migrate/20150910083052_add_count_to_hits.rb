class AddCountToHits < ActiveRecord::Migration
  def change
    add_column :users, :urls_count, :integer
    add_column :urls, :hits_count, :integer
  end
end
