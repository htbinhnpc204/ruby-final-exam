class AddAvatarLinkToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar_link, :string
  end
end
