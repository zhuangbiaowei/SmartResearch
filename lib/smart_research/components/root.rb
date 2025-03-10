module SmartResearch
  module Component
    class Root
      def self.build
        layout = RubyRich::Layout.new
        return layout
      end
    end
  end
end