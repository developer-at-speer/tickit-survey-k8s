class CreateEncryptionKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :encryption_keys do |t|
      t.text :key_hash
      t.text :iv

      t.timestamps
    end
  end
end
