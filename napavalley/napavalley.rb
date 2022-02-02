### Batch download and process CNRI resolution logs stats
require 'dotenv/load'

TASK = ARGV[0]
YEAR = ARGV[1]
MONTH = ARGV[2]

return puts "You gave me #{TASK} -- I have no idea what to do with that." unless YEAR && MONTH || TASK == "help"

case TASK
when "download"
  system("mkdir ~/downloads/datacite_logs_#{YEAR}#{MONTH}")
  system("cd ~/downloads/datacite_logs_#{YEAR}#{MONTH}")
  puts"https://loganalysis.handle.net/datacite/logs/DataCite-access.log-#{YEAR}#{MONTH}"
  system("
  curl -k --request GET --header 'authorization: Basic #{ENV['AUTH']}' --url https://loganalysis.handle.net/datacite/logs/DataCite-access.log-#{YEAR}#{MONTH}-ap-southeast-1.gz --output ~/downloads/datacite_logs_#{YEAR}#{MONTH}/DataCite-access.log-#{YEAR}#{MONTH}-ap-southeast-1.gz
  curl -k --request GET --header 'authorization: Basic #{ENV['AUTH']}' --url https://loganalysis.handle.net/datacite/logs/DataCite-access.log-#{YEAR}#{MONTH}-eu-west-1.gz --output ~/downloads/datacite_logs_#{YEAR}#{MONTH}/DataCite-access.log-#{YEAR}#{MONTH}-eu-west-1.gz
  curl -k --request GET --header 'authorization: Basic #{ENV['AUTH']}' --url https://loganalysis.handle.net/datacite/logs/DataCite-access.log-#{YEAR}#{MONTH}-us-east-1.gz --output ~/downloads/datacite_logs_#{YEAR}#{MONTH}/DataCite-access.log-#{YEAR}#{MONTH}-us-east-1.gz
  curl -k --request GET --header 'authorization: Basic #{ENV['AUTH']}' --url https://loganalysis.handle.net/datacite/logs/DataCite-access.log-#{YEAR}#{MONTH}-us-west-2.gz --output ~/downloads/datacite_logs_#{YEAR}#{MONTH}/DataCite-access.log-#{YEAR}#{MONTH}-us-west-2.gz
  " )
when "move"
  system("mkdir ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH}")
  system("mkdir ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH}_res")
  system("cp ~/downloads/datacite_logs_#{YEAR}#{MONTH}/* ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH}")
when "process"
  system("cd ~/datacite/doi-resolution-report/")
  system("python2.7 ~/datacite/doi-resolution-report/report.py ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH} ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH}_res")
when "push_html"
  system("cp ~/datacite/doi-resolution-report/datacite_logs_#{YEAR}#{MONTH}_res/resolutions_#{MONTH}_#{YEAR}.html ~/datacite/stats-portal/source/stats/resolution-report/")
when "s3ve"
  system("aws s3 cp ~/downloads/datacite_logs_#{YEAR}#{MONTH} s3://raw-resolution-logs.datacite.org/#{YEAR}#{MONTH}/ --recursive")
when "help"
  puts "your options are: move, process, push_html, s3ve"
else
  puts "You gave me #{TASK} -- I have no idea what to do with that."
end
