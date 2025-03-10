module Fixy
  class Document

    attr_accessor :debug_mode

    def generate_to_file(path, debug = false)
      File.open(path, 'w') do |file|
        file.write(generate(debug))
      end
    end

    def generate(debug = false)
      @debug_mode = debug
      @contents = []

      # Generate document based on user logic.
      build

      decorator.document(@contents.join)
    end

    def content
      @contents.join
    end

    private

    def build
      raise NotImplementedError
    end

    def decorator
      debug_mode ? Fixy::Decorator::Debug : Fixy::Decorator::Default
    end

    def prepend_record(record)
      @contents.insert(0, record.generate(debug_mode))
    end

    def append_record(record)
      @contents << record.generate(debug_mode)
    end

    def parse_record(klass, record)
      @contents << klass.parse(record, debug_mode)[:record]
    end
  end
end
