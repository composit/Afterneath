class AddEmbedUrlAndApprovedToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :embed_url, :string
    add_column :entries, :approved, :boolean
  end

  def self.down
    remove_column :entries, :embed_url
    remove_column :entries, :approved
  end
end
