class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.string :name
      t.integer :position
      t.text :content
      t.string :enterer
      t.string :enterer_url

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
