module Fixy
  module Formatter
    module Alphanumeric

      #
      # Alphanumeric Formatter
      #
      # Only contains printable characters and is
      # left-justified and filled with spaces.
      #

      def format_alphanumeric(input, byte_width)
        input_string = String.new(input.to_s).tr "#{self.class::LINE_ENDING_CRLF}#{line_ending}", ''
        result = []
        bytesize = 0

        if input_string.bytesize <= byte_width
          result << input_string
          bytesize = input_string.bytesize
        else
          input_string.each_char do |char|
            if bytesize + char.bytesize <= byte_width
              result << char
              bytesize += char.bytesize
            else
              break
            end
          end
        end

        result << (' ' * (byte_width - bytesize))
        result.join
      end
    end
  end
end
