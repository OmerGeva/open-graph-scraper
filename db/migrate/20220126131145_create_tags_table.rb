class CreateTagsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :og_type
      t.string :content
    end
  end
end
