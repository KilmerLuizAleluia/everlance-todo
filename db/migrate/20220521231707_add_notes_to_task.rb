class AddNotesToTask < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :notes, :string
  end
end
