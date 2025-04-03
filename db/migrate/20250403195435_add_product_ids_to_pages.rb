class AddProductIdsToPages < ActiveRecord::Migration[7.2]
  def change
    add_column :pages, :product_ids, :text
  end
end
