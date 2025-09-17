require "sequel"

class Embedding < Sequel::Model
  set_dataset :embeddings

  # 验证
  def validate
    super
    validates_presence [:source_id, :vector]
    validates_format /\d+(\.\d+)?/, :vector, message: "向量必须是浮点数数组"
  end

  # CRUD 操作封装
  class << self
    def create_embedding(source_id, vector)
      #create(
      #  source_id: source_id,
      #  vector: vector,
      #)
      DB["INSERT INTO embeddings (source_id, vector) VALUES (?,?)", source_id, vector].insert
    end

    def find_by_source(source_id)
      first(source_id: source_id)
    end

    def all_embeddings
      all
    end

    def update_embedding(id, attrs)
      embedding = first(id: id)
      embedding&.update(attrs)
    end

    def delete_embedding(id)
      embedding = first(id: id)
      embedding&.destroy
    end

    def delete_by_source(source_id)
      find_by_source(source_id)&.destroy
    end

    # 向量相似度搜索
    def search_by_vector(query_vector, limit = 5)
      # 使用 PostgreSQL 的 <-> 操作符计算余弦距离（值越小越相似）
      # 注意：需要安装 pgvector 扩展
      DB[
        "SELECT e.id, e.source_id, s.section_title, s.content, d.title as document_title, d.author, d.publication_date, d.url,
                (e.vector <-> ?) as distance
         FROM embeddings e
         JOIN source_sections s ON e.source_id = s.id
         JOIN source_documents d ON s.document_id = d.id
         ORDER BY e.vector <-> ?
         LIMIT ?",
        query_vector, query_vector, limit
      ].all
    end

    # 向量相似度搜索，支持标签优先级提升
    def search_by_vector_with_tag_boost(query_vector, tags = [], limit = 5)
      # 如果没有提供标签，使用普通的向量搜索
      if tags.empty?
        return search_by_vector(query_vector, limit)
      end

      # 构建标签匹配的SQL条件
      tag_conditions = tags.map { |tag| "t.name = ?" }.join(" OR ")
      tag_params = tags

      # 使用 PostgreSQL 的 <-> 操作符计算余弦距离（值越小越相似）
      # 对匹配标签的记录给予距离加权（降低距离值以提高优先级）
      DB[
        "SELECT e.id, e.source_id, s.section_title, s.content, d.title as document_title, d.author, d.publication_date, d.url,
                (e.vector <-> ?) * CASE
                  WHEN COUNT(st.tag_id) > 0 THEN 0.5  -- 匹配标签的记录距离减半（优先级提升）
                  ELSE 1.0  -- 不匹配标签的记录保持原距离
                END as distance
         FROM embeddings e
         JOIN source_sections s ON e.source_id = s.id
         JOIN source_documents d ON s.document_id = d.id
         LEFT JOIN section_tags st ON s.id = st.section_id
         LEFT JOIN tags t ON st.tag_id = t.id AND (#{tag_conditions})
         GROUP BY e.id, e.source_id, s.section_title, s.content, d.title, d.author, d.publication_date, d.url, e.vector
         ORDER BY distance
         LIMIT ?",
        query_vector, *tag_params, limit
      ].all
    end
  end
end
