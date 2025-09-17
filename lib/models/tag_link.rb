require "sequel"

class TagLink < Sequel::Model
  set_dataset :tag_links

  # 验证
  def validate
    super
    validates_presence [:source_tag_id, :target_tag_id]
  end

  # 关联关系
  many_to_one :source_tag, class: :Tag, key: :source_tag_id
  many_to_one :target_tag, class: :Tag, key: :target_tag_id

  # CRUD 操作封装
  class << self
    def create_link(source_tag_id, target_tag_id, relation_type = "related")
      create(
        source_tag_id: source_tag_id,
        target_tag_id: target_tag_id,
        relation_type: relation_type,
      )
    end

    def find_by_tags(source_tag_id, target_tag_id)
      first(source_tag_id: source_tag_id, target_tag_id: target_tag_id)
    end

    def links_for_tag(tag_id)
      where(source_tag_id: tag_id)
    end

    def update_link(source_tag_id, target_tag_id, attrs)
      link = find_by_tags(source_tag_id, target_tag_id)
      link&.update(attrs)
    end

    def delete_link(source_tag_id, target_tag_id)
      link = find_by_tags(source_tag_id, target_tag_id)
      link&.destroy
    end
  end
end
