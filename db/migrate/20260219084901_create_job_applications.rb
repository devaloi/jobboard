class CreateJobApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :job_applications do |t|
      t.references :job, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :cover_letter
      t.integer :status, null: false, default: 0
      t.datetime :status_changed_at

      t.timestamps
    end

    add_index :job_applications, %i[user_id job_id], unique: true
    add_index :job_applications, :status
  end
end
