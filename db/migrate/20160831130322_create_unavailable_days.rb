class CreateUnavailableDays < ActiveRecord::Migration
  def change
    create_table :unavailable_days do |t|
      t.string :description
      t.date :date, null: false, index: true

      t.timestamps null: false
    end
  end
end
