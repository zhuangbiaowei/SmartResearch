# Database schema
ActiveRecord::Schema.define(version: 2025_01_31_000000) do
  create_table :knowledge_entries do |t|
    t.string :topic, null: false
    t.text :content, null: false
    t.float :confidence, default: 0.0
    t.string :source
    t.timestamps
  end
end