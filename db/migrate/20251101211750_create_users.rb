class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :provider
      t.string :uid

      t.timestamps
    end
    
    add_index :users, [:provider, :uid], unique: true
    add_index :users, :email
  end
end
