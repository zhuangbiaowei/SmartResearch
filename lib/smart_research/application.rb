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

    def call_agent(agent_name, input_text, content_panel)
      reasoning = false
      reasoned = false
      agent = @agent_engine.agents[agent_name]
      SmartResearch.logger.info("agent is: #{agent_name}")
      agent.on_reasoning do |chunk|
        unless chunk.dig("choices", 0, "delta", "reasoning_content").empty?
          reasoned = true
          if reasoning == false
            content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + "AI Thinking: " + RubyRich::AnsiCode.reset
            reasoning = true
          end
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + chunk.dig("choices", 0, "delta", "reasoning_content") + RubyRich::AnsiCode.reset
          if chunk.dig("choices", 0, "finish_reason") == true
            content_panel.content += "\n"
          end
        end
      end
      agent.on_content do |chunk|
        unless chunk.dig("choices", 0, "delta", "content").empty?
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
          if chunk.dig("choices", 0, "finish") == true
            content_panel.content += "\n"
          end
        end
      end
      agent.on_tool_call do |msg|
        if msg[:status] == :start
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + "Call:" + RubyRich::AnsiCode.reset + "\n"
        elsif msg[:status] == :end
          content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + "Call tools completion.\n" + RubyRich::AnsiCode.reset
        else
          # content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + msg[:content].to_s + "\n" + RubyRich::AnsiCode.reset
        end
      end
      agent.on_logging do |msg|
        content_panel.content += RubyRich::AnsiCode.color(:cyan, true) + msg + RubyRich::AnsiCode.reset + "\n"
      end
      agent.please(input_text)
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
