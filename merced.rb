#### this scripts validates sushi report
### ruby merced.rb FILE_NAME

require 'json-schema'
require 'fileutils'
require 'json' 
require 'active_support' 


def validate_this_sushi report
  puts "this is being validated"
  sushi = JSON.parse(File.read(report))
  # schema = load_schema 
  results = JSON::Validator.fully_validate(USAGE_SCHEMA_FILE, sushi.to_json, :errors_as_objects => true)
  case results.empty?
  when true
    puts "valid"
  else
    puts "not valid"
    puts results
  end
end
  

USAGE_SCHEMA_FILE = "/Users/kristian/datacite/sashimi/lib/sushi_schema/sushi_usage_schema.json"
RESOLUTION_SCHEMA_FILE = "/Users/Kristian/datacite/sashimi/lib/sushi_schema/sushi_resolution_schema.json"


def load_schema
  if self.is_a?(ReportSubset)
    release = self.report.release
  else
    report = self.attributes.except("compressed")
    report.transform_keys! { |key| key.tr('_', '-') }
    release = report.dig("release")
  end
  file = case release
    when 'rd1' then USAGE_SCHEMA_FILE
    when 'drl' then RESOLUTION_SCHEMA_FILE
  end
  begin
    File.read(file)
  rescue
    puts 'must redo the settings file'
    {} # return an empty Hash object
  end
end

# validate_this_sushi("/Users/kristian/datacite/kishu/reports/datacite_resolution_report_2018-09_2.json")
# validate_this_sushi("/Users/kristian/Downloads/DSR-D1-2014-01-31-urn-node-KNB.json")
# validate_this_sushi("/Users/kristian/Downloads/2013-11-report/2013-11-pretty-print.json")

validate_this_sushi ARGV[0]
