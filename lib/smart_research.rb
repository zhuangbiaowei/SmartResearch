require "ruby_rich"
require "../smart_prompt/lib/smart_prompt"
require "../smart_agent/lib/smart_agent"

require_relative "./smart_research/application"
require_relative "./smart_research/learning_loop"
Dir["#{__dir__}/smart_research/components/*.rb"].each { |f| require_relative f }

module SmartResearch
  class CLI
    def self.start(argv)
      # Initialize the learning loop
      app = Application.new
      loop = LearningLoop.new(app)
      loop.run
    end
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.progname = self.name
    end
  end
end
