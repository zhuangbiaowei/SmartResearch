module SmartResearch
  module Component
    class Main
      def self.build
        layout = RubyRich::Layout.new(name: "main", ratio: 3)        
        return layout
      end
    end
  end
end

