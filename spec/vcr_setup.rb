require 'vcr'
require 'constants'

VCR.configure do |c|
  c.cassette_library_dir = FIXTURE_PATH + 'vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  # c.debug_logger = File.open('vcr.log', 'w')
end
