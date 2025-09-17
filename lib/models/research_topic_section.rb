require "sequel"

class ResearchTopicSection < Sequel::Model
  set_dataset :research_topic_sections

  # 允许对主键字段进行赋值
  unrestrict_primary_key

  # 验证
  def validate
    super
    validates_presence [:research_topic_id, :section_id]
  end

  # 关联关系
  many_to_one :research_topic, key: :research_topic_id
  many_to_one :source_section, key: :section_id

  # CRUD 操作封装
  class << self
    def create_link(research_topic_id, section_id)
      create(
        research_topic_id: research_topic_id,
        section_id: section_id,
      )
    end

    def find_by_topic_and_section(research_topic_id, section_id)
      first(research_topic_id: research_topic_id, section_id: section_id)
    end

    def links_for_topic(research_topic_id)
      where(research_topic_id: research_topic_id)
    end

    def links_for_section(section_id)
      where(section_id: section_id)
    end

    def update_link(research_topic_id, section_id, attrs)
      link = find_by_topic_and_section(research_topic_id, section_id)
      link&.update(attrs)
    end

    def delete_link(research_topic_id, section_id)
      link = find_by_topic_and_section(research_topic_id, section_id)
      link&.destroy
    end
  end
end
