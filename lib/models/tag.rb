# frozen_string_literal: true

class Tag < Sequel::Model
  # 关联关系
  one_to_many :wiki_page_tags
  many_to_many :wiki_pages, join_table: :wiki_page_tags, left_key: :tag_id, right_key: :page_id

  one_to_many :data_entities

  one_to_many :source_sections

  one_to_many :note_tag_links
  many_to_many :notes, join_table: :note_tag_links, left_key: :tag_id, right_key: :note_id

  one_to_many :source_tag_links, class: :TagLink, key: :source_tag_id
  one_to_many :target_tag_links, class: :TagLink, key: :target_tag_id

  # 研究主题关联
  many_to_many :research_topics, join_table: :research_topic_tags, left_key: :tag_id, right_key: :research_topic_id

  def related_tags
    TagLink.where(source_tag_id: id).map(&:target_tag)
  end

  def self.find_or_create_by_name(name)
    Tag.find(name: name) || Tag.create(name: name)
  end
end
