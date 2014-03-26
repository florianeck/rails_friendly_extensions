class CreateLabels < ActiveRecord::Migration
  
  def change
    create_table "friends_labels", :force => true do |t|
      t.string "attribute_name"
      t.string "label"
      t.text   "tooltip"
      t.text   "tooltip_docu"
      t.text   "search_tags"
    end
  end  
  
end  