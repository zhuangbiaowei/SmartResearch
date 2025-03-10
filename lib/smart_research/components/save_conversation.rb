module SmartResearch
  module Component
    class SaveConversation
      def self.build(conversation_name, live)
        width = conversation_name.display_width + 8
        width = 60 if width > 60
        dialog = RubyRich::Dialog.new(title: "保存对话", content: conversation_name, width: width, buttons: [:ok])
        dialog.live = live
        register_event_listener(dialog)
        return dialog
      end

      def self.register_event_listener(dialog)
        dialog.key(:enter){|event, live|
          live.layout.hide_dialog
        }
      end
    end
  end
end