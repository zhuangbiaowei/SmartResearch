module SmartResearch
  module Component
    class HelpDialog
      def self.build(live)
        display_content = "    帮助您进行深入、有效、专业的研究！\n    通过F2~F4切换工作状态。\n    最终帮您创作出高品质的作品！"
        dialog = RubyRich::Dialog.new(title: "帮助", content: display_content, width: 60, height: 10, buttons: [:ok])
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