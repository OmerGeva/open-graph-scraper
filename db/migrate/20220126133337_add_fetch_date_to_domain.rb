class AddFetchDateToDomain < ActiveRecord::Migration[6.1]
  def change
    add_column :domains, :last_fetched, :datetime
  end
end
