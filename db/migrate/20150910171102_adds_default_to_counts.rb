class AddsDefaultToCounts < ActiveRecord::Migration
  def change
    change_column :users, :urls_count, :integer, :default => 0
    change_column :urls, :hits_count, :integer, :default => 0
  end
end
