class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer  :parent_id
      t.string   :title
      t.text     :content
      t.integer  :value
    end
  end
end
