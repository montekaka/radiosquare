class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :name
      t.integer :podcast_id
      t.integer :file_size
      t.integer :lastmod
      t.string :url

      t.timestamps
    end
    add_index :episodes, :podcast_id
  end
end
