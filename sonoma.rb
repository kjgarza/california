require "rails"

total = 13000000

def pages options, total
  page = (options.dig(:page, :number) || 1).to_i

  if options.dig(:page, :size).present? 
    per_page = [options.dig(:page, :size).to_i, 1000].min
    max_number = per_page > 0 ? 10000/per_page : 1
  else
    per_page = 25
    max_number = 10000/per_page
  end
  page = page.to_i > 0 ? [page.to_i, max_number].min : 1
  offset = (page - 1) * per_page

  total_pages = (total.to_f / per_page).ceil

  puts "per page: #{per_page}"
  puts "total: #{total_pages}"
  puts "page: #{page}"
  puts "total #{per_page*total_pages}"
end


options = {
  page: {
    size: "2000",
    number: "1000"
  }
}
pages(options, total)


options = {
  page: {
    size: "50",
    number: "100"
  }
}
pages(options, total)

