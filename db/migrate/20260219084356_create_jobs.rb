class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.string :title, null: false
      t.string :location, null: false
      t.integer :salary_min
      t.integer :salary_max
      t.integer :job_type, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.date :expires_at
      t.integer :applications_count, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :jobs, :status
    add_index :jobs, :job_type
    add_index :jobs, :expires_at
    add_index :jobs, %i[status expires_at]
  end
end
