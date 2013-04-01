module Parser

  class DiagnosticsEngine
    attr_accessor :consumer

    attr_accessor :all_errors_are_fatal
    attr_accessor :ignore_warnings

    def initialize(consumer=nil)
      @consumer             = consumer

      @all_errors_are_fatal = false
      @ignore_warnings      = false
    end

    def process(diagnostic)
      if ignore?(diagnostic)
        # do nothing
      elsif raise?(diagnostic)
        raise Parser::SyntaxError, diagnostic.message
      elsif @consumer
        @consumer.call(diagnostic)
      end

      self
    end

    protected

    def ignore?(diagnostic)
      @ignore_warnings &&
            diagnostic.level == :warning
    end

    def raise?(diagnostic)
      (@all_errors_are_fatal &&
          diagnostic.level == :error) ||
        diagnostic.level == :fatal
    end
  end

end
