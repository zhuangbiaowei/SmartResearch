require_relative 'smart_research/application'
require_relative 'smart_research/learning_loop'

module SmartResearch
  class CLI
    def self.start(argv)
      # Initialize the learning loop
      app = Application.new
      loop = LearningLoop.new(app)
      loop.run
    end
  end
end
