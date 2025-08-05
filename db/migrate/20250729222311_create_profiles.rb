class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :github_url
      t.string :github_username
      t.integer :followers, default: 0
      t.integer :following, default: 0
      t.integer :stars, default: 0
      t.integer :contributions, default: 0
      t.string :avatar
      t.string :organization
      t.string :location
      t.string :short_url

      t.index :github_username
      t.index :short_url

      t.timestamps
    end
  end
end
