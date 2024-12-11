class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    unless column_exists?(:tasks, :user_id)
      add_column :tasks, :user_id, :integer
      add_index :tasks, :user_id
    end
  end
end
