require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'byebug'

def process_secure(url)
  tries = 3
  begin
    sleep 2
    amazon_results = Nokogiri::HTML(open(url))
    # amazon_results = Nokogiri::HTML(open('item.txt'))
    amazon_possibles = {}
    all_items = amazon_results.css('item')
    all_items.each_with_index do |item, idx|
      amazon_possibles[idx] = {
        asin: get_attr(item, 'asin'),
        parent_asin: get_attr(item, 'parentasin'),
        detail_page: get_attr(item, 'detailpageurl'),
        model_num: get_attr(item, 'model'),
        upc: get_attr(item, 'upc'),
        image: get_attr(item, 'largeimage/url'),
        more_offers: get_attr(item, 'moreoffersurl'),
        lowest_price: get_attr(item, 'offersummary/lowestnewprice/formattedprice')
      }

    end
  rescue
    tries -= 1
    if tries > 0
      p "failed get at this url. retrying..."
      p url
      retry
    end
    p "out of retries. failed."
    return 'unable to retrieve'
  end

  return amazon_possibles

end

def get_attr(item, atribute)
  if item.css(atribute).length > 0
    if item.css(atribute).length > 1
      return item.css(atribute).first.text
    end
    return item.css(atribute).text
  else
    return 'n/a'
  end
end
