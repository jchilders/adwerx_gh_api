class CreateGithubRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :github_repositories do |t|
      t.string :owner
      t.string :name
      t.string :url
      t.integer :stargazers_count

      t.timestamps
    end
    add_index :github_repositories, [:owner, :name], unique: true
    add_index :github_repositories, :url, unique: true
  end
end
