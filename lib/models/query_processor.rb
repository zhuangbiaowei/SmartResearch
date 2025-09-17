require "sequel"
require "json"

# 自然语言查询处理器
class QueryProcessor
  # 初始化
  def initialize(engine)
    @engine = engine
    @short_memory = ShortMemory.new
  end

  # 处理自然语言查询
  def process_query(query_text, limit = 5)
    # 将查询文本转换为向量
    results = []
    langs = ["简体中文", "繁体中文", "英语", "日语"]
    langs.each do |lang|
      tags = text_to_tags(query_text, lang)
      query_vector = text_to_vector(tags.join(","))
      # puts "查询标签: #{tags.join(", ")}" if tags.any?
      unless query_vector == "[]"
        query_results = Embedding.search_by_vector_with_tag_boost(query_vector, tags, limit)
        query_results.each do |r|
          results << r
        end
      end
    end

    # 去除重复项
    results.uniq! { |r| r[:url] }

    # 按照距离从小到大排序，并保留前10个结果
    results.sort_by! { |r| r[:distance] }
    results = results[0..limit * 2 - 1]
    return results
  end

  # 将文本转换为向量
  def text_to_vector(text)
    # 如果有 SmartPrompt 引擎，使用它来获取嵌入向量
    if @engine
      begin
        result = @engine.call_worker(:get_embedding, { text: text, length: 1024 })
        "[#{result.join(",")}]"
      rescue => e
        # puts "警告: 无法使用 SmartPrompt 获取嵌入向量: #{e.message}"
        # 如果失败，返回一个空数组（这里只是一个示例）
        "[]"
      end
    else
      # 如果没有 SmartPrompt 引擎，返回一个默认向量（这里只是一个示例）
      # puts "警告: SmartPrompt 引擎不可用，使用默认向量"
      "[]"
    end
  end

  # 将查询文本转换为标签
  def text_to_tags(text, lang = "简体中文")
    # 如果有 SmartPrompt 引擎，使用它来获取标签
    if @engine
      begin
        result = @engine.call_worker(:get_tags, { topic: "知识库查询", text: text, lang: lang })
        if result.class == Hash
          json_str = result.dig("choices", 0, "message", "content")
          json_str = json_str.gsub("```json\n", "").gsub("\n```", "").strip
          json_obj = JSON.parse(json_str)
          json_obj["Tags"]
        elsif result.class == String
          json_str = result
          json_str = json_str.gsub("```json\n", "").gsub("\n```", "").strip
          json_obj = JSON.parse(json_str)
          json_obj["Tags"]
        else
          []
        end
      rescue => e
        # puts "警告: 无法使用 SmartPrompt 获取标签: #{e.message}"
        []
      end
    else
      # 如果没有 SmartPrompt 引擎，返回空数组
      # puts "警告: SmartPrompt 引擎不可用，无法获取标签"
      []
    end
  end

  # 以自然语言的方式回答
  def natural_response(ask, result)
    result = @engine.call_worker(:summarize_search_results, { ask: ask, text: result })
    if result.class == Hash
      return result.dig("choices", 0, "message", "content")
    else
      return result
    end
  end

  # 格式化搜索结果
  def format_results(results)
    formatted_results = []

    results.each_with_index do |result, index|
      formatted_results << {
        rank: index + 1,
        distance: result[:distance],
        document_title: result[:document_title],
        section_title: result[:section_title],
        content: result[:content],
        author: result[:author],
        publication_date: result[:publication_date],
        url: result[:url],
      }
    end

    formatted_results
  end
end
