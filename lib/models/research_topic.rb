require "sequel"

class ResearchTopic < Sequel::Model
  set_dataset :research_topics

  # 验证
  def validate
    super
    validates_presence :name, message: "研究主题名称不能为空"
    validates_unique :name, message: "研究主题名称必须唯一"
  end

  # 关联关系
  many_to_many :tags, join_table: :research_topic_tags, left_key: :research_topic_id, right_key: :tag_id
  many_to_many :source_sections, join_table: :research_topic_sections, left_key: :research_topic_id, right_key: :section_id

  # CRUD 操作封装
  class << self
    def create_or_find_topic(name, description = nil)
      find_by_name(name) || create(
        name: name,
        description: description,
      )
    end

    def find_by_name(name)
      first(name: name)
    end

    def all_topics
      all
    end

    def update_topic(id, attrs)
      topic = first(id: id)
      topic&.update(attrs)
    end

    def delete_topic(id)
      topic = first(id: id)
      topic&.destroy
    end

    def find_by_tag(tag_id)
      join(:research_topic_tags, research_topic_id: :id).where(tag_id: tag_id)
    end
  end
end
