require 'cucumber/smart_ast/step_container'
require 'cucumber/smart_ast/step_template'

module Cucumber
  module SmartAst
    class ScenarioOutline < StepContainer
      include Enumerable
      include Tags
      
      def initialize(keyword, description, line, tags, feature)
        super(keyword, description, line, feature)
        @tags = tags
      end
      
      def create_examples(keyword, description, line, tags)
        Examples.new(keyword, description, line, self)
      end
      
      def add_step!(keyword, name, line)
        @steps << StepTemplate.new(keyword, name, line, self)
      end
      
      def examples(examples)
        @examples ||= []
        examples.steps = @steps
        @examples << examples
        examples
      end

      def scenarios
        scenarios = []
        @examples.each do |example|
          example.scenarios.each do |scenario|
            scenarios << scenario
          end
        end
        scenarios
      end
      
      def background_steps
        @parent.background_steps
      end
      
      def feature
        @parent
      end
      
      def language
        @parent.language
      end
      
      def title
        @description.split("\n").first
      end

      def each(&block)
        @examples.each { |examples| yield examples }
      end
    end
  end
end
