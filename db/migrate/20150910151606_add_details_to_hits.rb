class AddDetailsToHits < ActiveRecord::Migration
  def change
    add_column :hits, :city, :string
    add_column :hits, :zipcode, :string
    add_column :hits, :country, :string
  end
end
