# frozen_string_literal: true

module Cran
  class PackageService
    extend ApiMixin

    class << self
      def receive_each_package
        package = {}
        URI.open(PACKAGES_URL).each_line do |line|
          if line.include?('Package:')
            package[:name] = extract_value(line)
            next
          end

          if line.include?('Version:')
            package[:version] = extract_value(line)
            next
          end

          if line.include?('MD5sum:')
            package[:checksum] = extract_value(line)
            yield package
            package = {}
          end
        end
        nil
      end

      def extract_value(str)
        return if str.blank?

        str.split(':')&.last&.delete(" \t\r\n")
      end
    end
  end
end
