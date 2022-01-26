class CreateDomainsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :domains do |t|
      t.string :url
      t.string :name

      t.timestamps
    end
  end
end
