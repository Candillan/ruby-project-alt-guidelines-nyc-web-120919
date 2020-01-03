class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.integer  :actor_id
      t.integer  :show_id
      t.string   :importance
    end
  end
end
