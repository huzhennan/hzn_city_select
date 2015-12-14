class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name
      t.string :code
      t.belongs_to :province, index: true, foreign_key: true
    end
  end
end
