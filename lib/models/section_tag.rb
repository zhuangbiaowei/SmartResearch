require "sequel"

class SectionTag < Sequel::Model
  set_dataset :section_tags

  # 允许对主键字段进行赋值
  unrestrict_primary_key

  # 验证
  def validate
    super
    validates_presence [:section_id, :tag_id]
  end

  # 关联关系
  many_to_one :source_section, key: :section_id
  many_to_one :tag, key: :tag_id

  # CRUD 操作封装
  class << self
    def create_link(section_id, tag_id)
      first(section_id: section_id, tag_id: tag_id) || create(
        section_id: section_id,
        tag_id: tag_id,
      )
    end

    def find_by_section_and_tag(section_id, tag_id)
      first(section_id: section_id, tag_id: tag_id)
    end

    def links_for_section(section_id)
      where(section_id: section_id)
    end

    def links_for_tag(tag_id)
      where(tag_id: tag_id)
    end

    def delete_link(section_id, tag_id)
      link = find_by_section_and_tag(section_id, tag_id)
      link&.destroy
    end
  end
end
