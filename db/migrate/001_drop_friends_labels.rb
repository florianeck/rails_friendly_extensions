class DropFriendsLabels < ActiveRecord::Migration

  def change
    drop_table "friends_labels"
  end

end