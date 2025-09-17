require "sequel"

class SourceSection < Sequel::Model
  set_dataset :source_sections

  # 验证
  def validate
    super
    validates_presence [:document_id, :content], message: "文档ID和内容不能为空"
  end

  # 关联关系
  many_to_one :source_document, key: :document_id
  many_to_one :tag, key: :tag_id
  one_to_many :embeddings, key: :source_id

  # CRUD 操作封装
  class << self
    def create_section(document_id, content, section_title = nil, tag_id = nil, section_number = nil, created_at = nil)
      create(
        document_id: document_id,
        content: content,
        section_title: section_title,
        tag_id: tag_id,
        section_number: section_number,
        created_at: created_at,
      )
    end

    def find_by_document(document_id)
      where(document_id: document_id).order(:section_number)
    end

    def find_or_create_by_document_and_section_number(document_id, section_number)
      section = where(document_id: document_id, section_number: section_number).first
      section || create(document_id: document_id, section_number: section_number)
    end

    def find_by_tag(tag_id)
      where(tag_id: tag_id)
    end

    def all_sections
      all
    end

    def update_section(id, attrs)
      section = first(id: id)
      section&.update(attrs)
    end

    def delete_section(id)
      section = first(id: id)
      section&.destroy
    end
  end
end
