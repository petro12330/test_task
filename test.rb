require 'curb'
require 'nokogiri'
require 'csv'


def html_page(url)
  html = Curl::Easy.perform(url)
  return Nokogiri::HTML(html.body_str)
end

i='https://www.petsonic.com/comida-lata-para-perros-royal-canin-veterinary-diets-renal-humedo-finas-laminas-gelatina-150-gr.html'


doc = html_page(i)
# puts 'Записываю данные с ' + i
#
# img = doc.xpath("//span[@id='view_full_size']/img/@src")
# name = doc.xpath("//h1/text()")
# size = doc.xpath("//label/span[@class='radio_label']/text()")
# price = doc.xpath("//label/span[@class='price_comb']/text()")
# puts (name.to_s)
class Product
  def initialize (html)
    @html = html
  end

  def get_info
    @img = @html.xpath("//span[@id='view_full_size']/img/@src")
    @name = @html.xpath("//h1/text()")
    @size = @html.xpath("//label/span[@class='radio_label']/text()")
    @price = @html.xpath("//label/span[@class='price_comb']/text()")
    @info_list=[]
    for i in 0..(@size.count-1) do
          @info_list += [(@name.to_s+' - '+@size[i].to_s), @price[i], @img]
    end
    return @info_list
  end
end

prod= Product.new(doc)
puts prod.get_info
