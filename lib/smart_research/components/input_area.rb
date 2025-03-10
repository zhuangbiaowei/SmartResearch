module SmartResearch
  module Component
    class InputArea
      def self.build
        layout = RubyRich::Layout.new(name: "input_area", size: 8)
        draw_view(layout)
        register_event_listener(layout)
        return layout
      end

      def self.draw_view(layout)        
        layout.update_content(RubyRich::Panel.new(
          "> ",
          title: "交流与探索 (F6 = 换行，↑/↓ = 切换聊天历史) model: Pro/deepseek-ai/DeepSeek-R1",
          border_style: :cyan
        ))
      end

      def self.register_event_listener(layout)
        layout.key(:f6){|event, live|
          input_panel = live.find_panel("input_area")
          input_panel.content += "\n> "
          live.params[:input_pos] = 2
          live.params[:prompt_list][-1] = input_panel.content
        }
        layout.key(:string){|event, live|
          input_panel = live.find_panel("input_area")
          input_pos = live.params[:input_pos]
          input_str = event[:value]
          if input_pos == input_panel.content.split("\n").last.to_s.size
            input_panel.content = input_panel.content + input_str
          else
            input_panel.content = input_panel.content[0..input_pos-1].to_s + input_str + input_panel.content[input_pos..-1].to_s
          end
          live.params[:input_pos] = input_pos + 1
          live.params[:prompt_list][-1] = input_panel.content
        }
        layout.key(:enter){|event, live|
          input_panel = live.find_panel("input_area")
          unless input_panel.content == "> "
            arr = input_panel.content.split("\n").map { |str| str[2..-1] }          
            input_text = arr.join("\n")
            content_panel = live.find_panel("content")
            i = 0
            arr.each do |line|
              if i == 0
                content_panel.content += RubyRich::AnsiCode.color(:green) + "User: " + line + RubyRich::AnsiCode.reset + "\n"
              else
                content_panel.content += RubyRich::AnsiCode.color(:green) + "      " + line + RubyRich::AnsiCode.reset + "\n"
              end
              i += 1
            end
            live.params[:prompt_list] << "> "
            live.params[:prompt_no] += 1
            live.params[:input_pos] = 2
            live.params[:thread] = Thread.new {
              live.listening = false
              input_panel.border_style = :red
              input_panel.content = "> "
              input_panel.home
              content_panel.border_style = :green
              live.app.call_worker(input_text, content_panel, live.params[:use_name], live.params[:model_name]) 
              input_panel.border_style = :cyan            
              content_panel.border_style = :white
              conversation_name = live.params[:current_conversation_name]
              if conversation_name
                File.open("./conversations/#{conversation_name}.md", "w") do |f|
                  f.puts content_panel.content
                end
              end
              live.listening = true
            }
            live.params[:prompt_list][-1] = input_panel.content
          end
        }
        layout.key(:delete){|event, live|
          input_panel = live.find_panel("input_area")
          input_pos = live.params[:input_pos]
          arr = input_panel.content.split("\n")
          text = arr.last
          if input_pos == text.size - 1 && input_pos >= 2
            input_panel.content = input_panel.content[0..-2]
          elsif input_pos.between?(2, text.size - 2)
            arr[-1] = text[0..input_pos-1].to_s + text[input_pos+1..-1].to_s
            input_panel.content = arr.join("\n")
          end
          live.params[:prompt_list][-1] = input_panel.content
        }
        layout.key(:backspace){|event, live|
          input_panel = live.find_panel("input_area")
          input_pos = live.params[:input_pos]
          arr = input_panel.content.split("\n")
          text = arr.last
          if input_pos > text.size - 1 && input_pos > 2
            arr[-1] = text[0..-2]
            input_panel.content = arr.join("\n")
            live.params[:input_pos] -= 1 if input_pos > 2
          elsif input_pos.between?(3, text.size - 1)
            arr[-1] = text[0..input_pos-2].to_s + text[input_pos..-1].to_s
            input_panel.content = arr.join("\n")
            live.params[:input_pos] -= 1 if input_pos > 0
          elsif input_pos==3
            arr[-1] = text[1..-1]
            input_panel.content = arr.join("\n")
            live.params[:input_pos] = 2
          elsif input_pos==2 && arr.size>1
            input_panel.content = arr[0..-2].join("\n")
            live.params[:input_pos] = arr[-2].size
          end
          live.params[:prompt_list][-1] = input_panel.content
        }
        layout.key(:left){|event, live|
          live.params[:input_pos] -= 1 if live.params[:input_pos] > 2
        }
        layout.key(:right){|event, live|
          input_panel = live.find_panel("input_area")
          live.params[:input_pos] += 1 if live.params[:input_pos] < input_panel.content.size
        }
        layout.key(:up){|event, live|
          input_panel = live.find_panel("input_area")
          if live.params[:prompt_no] > 0
            live.params[:current_prompt] = input_panel.content if live.params[:prompt_no]==live.params[:prompt_list].size-1
            live.params[:prompt_no] -= 1
            input_panel.content = live.params[:prompt_list][live.params[:prompt_no]]
            live.params[:input_pos] = input_panel.content.split("\n").last.size
          end
        }
        layout.key(:down){|event, live|
          input_panel = live.find_panel("input_area")
          if live.params[:prompt_no] < live.params[:prompt_list].size-1
            live.params[:prompt_no] += 1
            if live.params[:prompt_no] == live.params[:prompt_list].size-1
              input_panel.content = live.params[:current_prompt]
            else
              input_panel.content = live.params[:prompt_list][live.params[:prompt_no]]
            end
            live.params[:input_pos] = input_panel.content.split("\n").last.size
          end
        }
      end
    end
  end
end