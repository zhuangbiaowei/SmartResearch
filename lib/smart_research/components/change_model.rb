module SmartResearch
  module Component
    class ChangeModel
      def self.models
        [
          ["SiliconFlow", "Pro/deepseek-ai/DeepSeek-R1"],
          ["SiliconFlow", "Pro/deepseek-ai/DeepSeek-V3"],
          ["SiliconFlow", "Qwen/QwQ-32B"],
          ["SiliconFlow", "Qwen/QVQ-72B-Preview"],
          ["ollama", "deepseek-r1"]
        ]
      end
      def self.build(live)
        i = 0
        display_content = ""
        models.each do |model|
          i += 1
          display_content += "#{i}. #{model[0]}  #{model[1]} \n"
        end
        dialog = RubyRich::Dialog.new(title: "切换模型", content: display_content, width: 80, height: 20, buttons: [:cancel])
        dialog.live = live
        register_event_listener(dialog)
        return dialog
      end
      def self.register_event_listener(dialog)
        dialog.key(:escape){|event, live|
          live.layout.hide_dialog
        }
        dialog.key(:string){|event, live|
          key_value = event[:value].to_i
          model = models[key_value-1]
          live.params[:use_name] = model[0]
          live.params[:model_name] = model[1]
          input_panel = live.find_panel("input_area")
          input_panel.title = "交流与探索 (F6 = 换行，↑/↓ = 切换聊天历史)  model: #{model[1]}"          
          live.layout.hide_dialog
        }
      end
    end
  end
end