# frozen_string_literal: true

require 'open-uri'
require 'net/http'
require 'tempfile'

module Cran
  module ApiMixin
    HOST = 'https://cran.r-project.org'
    CONTRIB_DIR_URL = 'src/contrib'
    PACKAGES_URL = "#{HOST}/#{CONTRIB_DIR_URL}/PACKAGES"
  end
end
