class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.integer  :user_id
      t.integer  :show_id
      t.integer  :rating
      t.string   :review
      t.boolean  :seen
      t.datetime :date
    end
  end
end
