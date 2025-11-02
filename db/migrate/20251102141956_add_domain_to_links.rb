class AddDomainToLinks < ActiveRecord::Migration[7.2]
  def change
    add_column :links, :domain, :string
  end
end
