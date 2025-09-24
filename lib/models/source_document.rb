require "sequel"

class SourceDocument < Sequel::Model
  set_dataset :source_documents

  # 验证
  def validate
    super
    validates_presence :title, message: "文档标题不能为空"
  end

  # 关联关系
  one_to_many :source_sections, key: :document_id
  one_to_many :embeddings, key: :source_id

  # 下载状态操作
  def download_state
    self[:download_state]
  end

  def download_state=(state)
    self[:download_state] = state
  end

  # CRUD 操作封装
  class << self
    def create_document(title, author = nil, publication_date = nil, language = nil, description = nil)
      create(
        title: title,
        author: author,
        publication_date: publication_date,
        language: language,
        description: description,
      )
    end

    def find_by_title(title)
      first(title: title)
    end

    def all_documents
      all
    end

    def update_document(id, attrs)
      document = first(id: id)
      document&.update(attrs)
    end

    def delete_document(id)
      document = first(id: id)
      document&.destroy
    end

    def find_by_author(author)
      where(author: author)
    end

    def find_by_language(language)
      where(language: language)
    end
  end
end
