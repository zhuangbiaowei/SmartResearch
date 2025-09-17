require "sequel"

class ResearchTopicTag < Sequel::Model
  set_dataset :research_topic_tags

  # 允许对主键字段进行赋值
  unrestrict_primary_key

  # 验证
  def validate
    super
    validates_presence [:research_topic_id, :tag_id]
  end

  # 关联关系
  many_to_one :research_topic, key: :research_topic_id
  many_to_one :tag, key: :tag_id

  # CRUD 操作封装
  class << self
    def create_link(research_topic_id, tag_id)
      first(research_topic_id: research_topic_id, tag_id: tag_id) || create(
        research_topic_id: research_topic_id,
        tag_id: tag_id,
      )
    end

    def find_by_topic_and_tag(research_topic_id, tag_id)
      first(research_topic_id: research_topic_id, tag_id: tag_id)
    end

    def links_for_topic(research_topic_id)
      where(research_topic_id: research_topic_id)
    end

    def links_for_tag(tag_id)
      where(tag_id: tag_id)
    end

    def update_link(research_topic_id, tag_id, attrs)
      link = find_by_topic_and_tag(research_topic_id, tag_id)
      link&.update(attrs)
    end

    def delete_link(research_topic_id, tag_id)
      link = find_by_topic_and_tag(research_topic_id, tag_id)
      link&.destroy
    end
  end
end
