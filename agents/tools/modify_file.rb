SmartAgent::Tool.define :modify_file do
  desc "基于diff文本修改文件内容"
  param_define :filename, "要修改的文件路径", :string
  param_define :diff_txt, "diff格式的修改内容，包含+/-行", :string

  tool_proc do
    filename = input_params[:filename]
    diff_txt = input_params[:diff_txt]

    unless File.exist?(filename)
      return "错误: 文件 #{filename} 不存在"
    end

    original_content = File.read(filename)
    lines = original_content.lines

    diff_lines = diff_txt.lines
    line_number = 1

    diff_lines.each do |diff_line|
      case diff_line[0]
      when "+"
        # 添加行
        content = diff_line[1..-1].chomp
        if line_number > lines.length
          lines << content + "\n"
        else
          lines.insert(line_number - 1, content + "\n")
        end
        line_number += 1
      when "-"
        # 删除行
        if line_number <= lines.length
          lines.delete_at(line_number - 1)
        end
        # 不增加行号，因为删除了当前行
      when " "
        # 未修改的行，只是前进行号
        line_number += 1
      end
    end

    File.write(filename, lines.join)

    "文件 #{filename} 修改成功，共 #{lines.length} 行"
  end
end
