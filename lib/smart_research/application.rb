# Application configuration
module SmartResearch
  class Application
    attr_accessor :layout, :engine

    def initialize
      @layout = Component::Root.build
      @layout.split_row(
        Component::Main.build,        
        Component::Sidebar.build
      )
  
      @layout["main"].split_column(
        Component::Content.build,
        Component::InputArea.build
      )
      @engine = SmartPrompt::Engine.new("./config/llm_config.yml")
      SmartResearch.logger = Logger.new("./log/app.log")
    end

    def call_worker(input_text, content_panel, use_name, model_name)
      reasoning = false
      reasoned = false
      use_name = "SiliconFlow" unless use_name
      model_name = "Pro/deepseek-ai/DeepSeek-R1" unless model_name
      @engine.call_worker_by_stream(:smart_agent, {text: input_text, use_name: use_name, model_name: model_name}) do |chunk, _bytesize|
        if chunk.dig("choices", 0, "delta", "reasoning_content")
          reasoned = true
          if reasoning == false
            content_panel.content += RubyRich::AnsiCode.color(:blue) + "AI Thinking: " + RubyRich::AnsiCode.reset + "\n"
            reasoning = true
          end
          content_panel.content += chunk.dig("choices", 0, "delta", "reasoning_content")
        end
        if chunk.dig("choices", 0, "delta", "content")
          if reasoning == true
            if reasoned == true
              content_panel.content += RubyRich::AnsiCode.color(:blue) + "AI Talking: " + RubyRich::AnsiCode.reset + "\n"
              reasoning = false
            end
          else
            if reasoned == false
              content_panel.content += RubyRich::AnsiCode.color(:blue) + "AI Talking: " + RubyRich::AnsiCode.reset + "\n"
              reasoned = true
            end
          end
          content_panel.content += chunk.dig("choices", 0, "delta", "content")
        end
      end
      content_panel.content += "\n"
    end

    def get_conversation_name(content)
      return @engine.call_worker(:get_conversation_name, {content: content})
    end

    def start      
      RubyRich::Live.start(@layout, refresh_rate: 24) do |live|
        live.params[:input_pos] = 2
        live.params[:prompt_list] = ["> "]
        live.params[:prompt_no] = 0
        live.params[:current_prompt] = ""
        live.listening = true
        live.app = self
      end
    end
  end
end