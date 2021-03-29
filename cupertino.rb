#This script gets a usage report and performs a small audit. it checks that investigation and request are correct.
# Fixes: https://github.com/datacite/datacite/issues/435

require "maremma"

API_URL = "https://api.datacite.org"
REPORT_UID = ARG[0]


def get_report 
  query = "#{API_URL}/reports/#{REPORT_UID}"
  json = Maremma.get(query).body.dig("data")
  json.map { |item| item.dig("id") }
end


def get_dataset_list report

end

def audit_usage dataset

end

def loop_list list
  list.map do |dataset| 
    {report: REPORT_UID , dataset: dataset.doi, audit: audit_usage(dataset)}
  end
end

def to_csv data
  CSV.open("report_audit_#{REPORT_UID}.csv", "wb") do |csv|
    csv << data.first.keys # adds the attributes name on the first line
    data.each do |hash|
      csv << hash.values unless hash[:host].empty?
    end
  end
end

def main 
  report = get_report
  list  = get_dataset_list report
  audit = loop_list list
  to_csv audit
end

main ARG