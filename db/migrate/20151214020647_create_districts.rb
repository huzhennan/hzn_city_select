class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.string :code
      t.belongs_to :city, index: true, foreign_key: true
    end
  end
end
