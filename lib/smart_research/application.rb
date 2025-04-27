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
      @agent_engine = SmartAgent::Engine.new("./config/agent.yml")
      SmartResearch.logger = Logger.new("./log/app.log")
    end

    def call_agent(input_text, content_panel, agent_name)
      reasoning = false
      reasoned = false
      agent = @agent_engine.agents[agent_name]
      SmartResearch.logger.info("agent is:" + agent.to_s)
      agent.on_reasoning do |chunk|
        reasoned = true
        if reasoning == false
          content_panel.content += RubyRich::AnsiCode.color(:blue) + "AI Thinking: " + RubyRich::AnsiCode.reset + "\n"
          reasoning = true
        end
        content_panel.content += chunk.dig("choices", 0, "delta", "reasoning_content")
      end
      agent.on_content do |chunk|
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
      agent.on_tool_call do |msg|
        if msg[:status] == :start
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + "Call:" + RubyRich::AnsiCode.reset + "\n"
        elsif msg[:status] == :end
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + "Call tools completion.\n" + RubyRich::AnsiCode.reset
        else
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + msg[:content] + RubyRich::AnsiCode.reset
        end
      end
      agent.please(input_text)
      content_panel.content += "\n"
    end

    def call_worker(input_text, content_panel, use_name, model_name)
      reasoning = false
      reasoned = false
      use_name = "SiliconFlow" unless use_name
      model_name = "Pro/deepseek-ai/DeepSeek-R1" unless model_name
      @engine.call_worker_by_stream(:smart_agent, { text: input_text, use_name: use_name, model_name: model_name }) do |chunk, _bytesize|
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

    def clear_history_messages
      @engine.clear_history_messages
    end

    def get_conversation_name(content)
      return @engine.call_worker(:get_conversation_name, { content: content })
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
