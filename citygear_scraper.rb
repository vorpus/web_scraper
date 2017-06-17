require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'byebug'

current_page = ''
site = 'citygear'
next_page = "http://www.citygear.com/catalog/shoes/page/1.html"

all_items = {}

while current_page != next_page
  p "parsing #{next_page}"
  current_page = next_page
  single_page_html = Nokogiri::HTML(open(next_page))
  items = single_page_html.css("li.item")
  items.each do |item|
    item_name = item.css("a")[1]['title']
    item_price = item.css("span.price").size > 0 ? item.css("span.price").last.inner_html.strip : 'no price'

    all_items[item_name] = {
      name: item.css("a")[1]['title'],
      link: item.css("a")[1]['href'],
      thumb: item.css("img")[0]['src'],
      color: item.css("a/span").children.text,
      price: item_price
    }
  end

  if single_page_html.css("a.i-next").size > 0
    next_page = single_page_html.css("a.i-next")[0]['href']
  end

end

File.open("#{site}.json",'w') do |s|
  s.puts all_items.to_json
end
