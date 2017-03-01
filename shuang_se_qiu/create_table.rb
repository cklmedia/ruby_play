class CreateTable < ActiveRecord::Migration
  def change
    create_table :shuang_se_qius do |t|
      (1..6).each do |i|
        t.integer "red_#{i}".to_sym
      end
      t.integer :blue
      t.string :phase
      t.integer :award
      t.timestamps
    end
  end
end
