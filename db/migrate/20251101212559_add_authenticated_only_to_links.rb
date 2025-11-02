class AddAuthenticatedOnlyToLinks < ActiveRecord::Migration[7.2]
  def change
    add_column :links, :authenticated_only, :boolean, default: false, null: false
  end
end
