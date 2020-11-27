require 'curb'
require 'nokogiri'
require 'csv'

def html_page(html)
  html = Curl::Easy.perform(html)
  return Nokogiri::HTML(html.body_str)
end


class Product
  def initialize (html)
    @html = html
  end

  def html_page(url)
    html = Curl::Easy.perform(url)
    return Nokogiri::HTML(html.body_str)
  end

  def save_info  (file_name)
    @file_name=file_name
    @img = @html.xpath("//span[@id='view_full_size']/img/@src")
    @name = @html.xpath("//h1/text()")
    @size = @html.xpath("//label/span[@class='radio_label']/text()")
    @price = @html.xpath("//label/span[@class='price_comb']/text()")
    @info_list=[]
    CSV.open(@file_name+".csv","a") do |a|
      for i in 0..(@size.count-1) do
            a << [(@name.to_s+' - '+@size[i].to_s), @price[i],@img]
      end
    end
  end
end



class All_products

  def initialize (html)
    @html = html
    @number_page = 2
    @page = ''
    @full_list = []
    @file_name='123'
  end

  def save_one_product
      for @link in @links
        puts 'Записываю данные с ' + @link
        @prod= Product.new(html_page(@link))
        @prod.save_info(@file_name)
      end




  end



  def products_list

    CSV.open(@file_name+".csv","w") do |wr|
      wr << ["Name", "price", "image"]
    end
    while true # понимаю насколько это медленно и глупо, но пока другой алгоритм не подобрал
      @doc = html_page(@html+@page)
      @kol_vo = @doc.xpath("//button[@class='loadMore next button lnk_view btn btn-default']/span/text()").count
      if @kol_vo == 1
        @page = '?p=' + @number_page.to_s
        @number_page = @number_page + 1
        @links = @doc.xpath("//div[@class='product-desc display_sd']/a/@href")
        @full_list += @links
        for @link in @links
          html_page(links)
          @prod= Product.new(@doc)

        end
      else
        break
      end
    end# ооооооочень долгая конструкция, оптимизирую ее первым делом(если этот комент висит, значит не опитимизировал((()
    puts 'Нашел список всех продуктов. Я насчитал ' + @full_list.count.to_s

  end
end

url_page = 'https://www.petsonic.com/comida-lata-para-perros/'
# file_name = gets.chomp()
prod = All_products.new(url_page)
prod.products_list
# while true # понимаю насколько это медленно и глупо, но пока другой алгоритм не подобрал
#   doc = html_page(url_page+page)
#   kol_vo = doc.xpath("//button[@class='loadMore next button lnk_view btn btn-default']/span/text()").count
#   if kol_vo == 1
#     page = '?p=' + number_page.to_s
#     number_page = number_page + 1
#     links = doc.xpath("//div[@class='product-desc display_sd']/a/@href")
#     full_list += links
#   else
#     break
#   end
# end# ооооооочень долгая конструкция, оптимизирую ее первым делом(если этот комент висит, значит не опитимизировал((()
# puts 'Нашел список всех продуктов. Я насчитал ' + full_list.count.to_s





















#
#
#
#


# puts "Файл " + file_name + ' записан.'
