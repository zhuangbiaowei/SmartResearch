module SmartResearch
  module Component
    class Sidebar
      def self.build
        layout = RubyRich::Layout.new(name: "sidebar", size: 26)
        draw_view(layout)
        register_event_listener(layout)
        return layout
      end

      def self.draw_view(layout)
        layout.update_content(RubyRich::Panel.new(
          "[F1] 帮助\n" +
          "[F2] 交流与探索\n" +
          "[F3] 整理知识库\n" +
          "[F4] 创作与输出\n" +
          "----------------------\n" +
          "[Ctrl+N] 开启新对话\n" +
          "[Ctrl+D] 删除对话\n" +
          "[Ctrl+S] 保存对话\n" +
          "[Ctrl+O] 加载历史对话\n" +
          "----------------------\n" +
          "[Ctrl+C] 退出",
          title: "快捷方式",
          border_style: :green,
        ))
      end

      def self.register_event_listener(layout)
        layout.key(:f1) { |event, live|
          dialog = HelpDialog.build(live)
          live.layout.show_dialog(dialog)
        }
        layout.key(:f2) { |event, live|
          live.params[:model] = "chat"
          input_panel = live.find_panel("input_area")
          if input_panel.border_style == :cyan
            input_panel.title = "交流与探索 (F6 = 换行，↑/↓ = 切换聊天历史)"
            input_panel.content = "> "
            content_panel = live.find_panel("content")
            content_panel.home
            content_panel.content = ""
          end
        }
        layout.key(:f3) { |event, live|
          live.params[:model] = "ask"
          input_panel = live.find_panel("input_area")
          if input_panel.border_style == :cyan
            input_panel.title = "整理知识库 (h = 帮助)"
            input_panel.content = "> "
            content_panel = live.find_panel("content")
            content_panel.home
            content_panel.content = ""
          end
        }
        layout.key(:f4) { |event, live|
          live.params[:model] = "write"
          input_panel = live.find_panel("input_area")
          if input_panel.border_style == :cyan
            input_panel.title = "创作与输出 (F6 = 换行，↑/↓ = 切换聊天历史)"
            input_panel.content = "> "
            content_panel = live.find_panel("content")
            content_panel.home
            content_panel.content = ""
          end
        }
        layout.key(:ctrl_c) { |event, live| live.stop }
        layout.key(:ctrl_s) { |event, live|
          conversation_name = live.params[:current_conversation_name]
          content_panel = live.find_panel("content")
          unless conversation_name
            name = live.app.get_conversation_name(content_panel.content.split("\n")[0..30].join("\n"))
            name.gsub!("\"", "")
            conversation_name = name
            live.params[:current_conversation_name] = conversation_name
            content_panel.title = conversation_name
            dialog = SaveConversation.build(conversation_name, live)
            live.layout.show_dialog(dialog)
          else
            dialog = SaveConversation.build("已经保存过了，对话名称为：" + conversation_name, live)
            live.layout.show_dialog(dialog)
          end
          File.open("./conversations/#{conversation_name}.md", "w") do |f|
            f.puts content_panel.content
          end
        }
        layout.key(:ctrl_o) { |event, live|
          files = Dir["./conversations/*.md"]
          dialog = LoadConversation.build(files, live)
          live.layout.show_dialog(dialog)
        }
        layout.key(:ctrl_n) { |event, live|
          SmartAgent.prompt_engine.clear_history_messages
          content_panel = live.find_panel("content")
          content_panel.content = ""
          content_panel.title = "聊天窗"
          content_panel.home
          live.params[:current_conversation_name] = nil
        }
      end
    end
  end
end
