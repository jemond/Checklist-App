class AddEmailsToChecklists < ActiveRecord::Migration
  def self.up
    add_column :checklists, :emails, :string
  end

  def self.down
    remove_column :checklists, :emails
  end
end
