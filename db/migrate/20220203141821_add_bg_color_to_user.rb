class AddBgColorToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :background_color, :string, default: '#e0e7ff'
  end
end
