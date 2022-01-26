class AddTagsToDomains < ActiveRecord::Migration[6.1]
  def change
    add_reference :tags, :domain, foreign_key: true
  end
end
