module Fixy
  module Formatter
    module Numeric
      #
      # Numeric Formatter
      #
      # May contain any digit from 0 through 9,
      # and is right-justified and zero-filled.
      #

      def format_numeric(input, length)
        input_as_string = input.to_s

        unless input.nil?
          raise ArgumentError, "Invalid Input (only digits are accepted) (input: #{input})" unless input_as_string =~ /^\d+$/
          raise ArgumentError, "Not enough length (input: #{input}, length: #{length})" if input_as_string.length > length
        end

        input_as_string.rjust(length, '0')
      end
    end
  end
end
