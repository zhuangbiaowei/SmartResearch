module SmartResearch
  module Component
    class LoadConversation
      def self.build(files, live)
        @@files = files
        @@page_count = 1
        @@current_page = 1
        display_content = build_content(files, 1)
        dialog = RubyRich::Dialog.new(title: "加载对话", content: display_content, width: 80, height: 20, buttons: [:cancel])
        dialog.live = live
        register_event_listener(dialog)
        return dialog
      end

      def self.build_content(files, page_num)
        display_content = ""
        i = 0
        b = (page_num - 1) * 9
        e = page_num * 9 - 1
        files[b..e].each do |file|
          i += 1
          conversation_name = file.gsub("./conversations/","").gsub(".md","")
          display_content = display_content + "#{i}: " + conversation_name + "\n"
        end
        if files.size>9
          page_count = @@page_count = (files.size / 9.0).ceil
          current_page = @@current_page = page_num
          display_content = display_content + " \n"*(10-files[b..e].size)+ " "*33 + "←  " + current_page.to_s+"/" + page_count.to_s + "  →"
        end
        return display_content
      end

      def self.register_event_listener(dialog)
        dialog.key(:escape){|event, live|
          live.layout.hide_dialog
        }
        dialog.key(:string){|event, live|
          key_value = event[:value].to_i
          if key_value >=1 && key_value <=9
            value = (@@current_page-1)*9+key_value-1
            if @@files[value]
              live.params[:current_conversation_name]=@@files[value].gsub("./conversations/","").gsub(".md","")
              live.layout.hide_dialog
            end
          end
        }
        dialog.key(:left){|event, live|          
          if @@current_page>1
            @@current_page -= 1
            display_content = build_content(@@files, @@current_page)
            live.layout.dialog.content = display_content
          end
        }
        dialog.key(:right){|event, live|
          if @@current_page<@@page_count
            @@current_page += 1
            display_content = build_content(@@files, @@current_page)
            live.layout.dialog.content = display_content
          end
        }
        dialog.on(:close){|event, live|
          conversation_name = live.params[:current_conversation_name]
          if conversation_name
            content_panel = live.find_panel("content")
            content = File.read("./conversations/"+conversation_name+".md")
            content_panel.content = content
            content_panel.title = conversation_name
          end
        }
      end
    end
  end
end