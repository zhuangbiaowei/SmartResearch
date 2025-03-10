module SmartResearch
  module Component
    class Content
      def self.build
        layout = RubyRich::Layout.new(name: "content", ratio: 4)
        draw_view(layout)
        register_event_listener(layout)
        return layout
      end

      def self.draw_view(layout)        
        layout.update_content(RubyRich::Panel.new(
          "",
          title: "聊天窗"
        ))
      end

      def self.register_event_listener(layout)
        layout.key(:page_up){|event, live|
          content_panel = live.find_panel("content")
          content_panel.page_up
        }
        layout.key(:page_down){|event, live|
          content_panel = live.find_panel("content")
          content_panel.page_down
        }
        layout.key(:home){|event, live|
          content_panel = live.find_panel("content")
          content_panel.home
        }
        layout.key(:end){|event, live|
          content_panel = live.find_panel("content")
          content_panel.end
        }
      end
    end
  end
end