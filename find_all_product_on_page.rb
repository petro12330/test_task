require 'curb'
require 'curb'
require 'nokogiri'
require 'csv'

class Product

  def initialize (url)
    @html = Nokogiri::HTML ((Curl::Easy.perform(url)).body_str)
  end

  def get_info (file_name)
    @file_name = file_name
    @img = @html.xpath("//span[@id='view_full_size']/img/@src")
    @name = @html.xpath("//h1/text()")
    @size = @html.xpath("//label/span[@class='radio_label']/text()")
    @price = @html.xpath("//label/span[@class='price_comb']/text()")
    CSV.open(@file_name+".csv","a") do |a|
      for i in 0..(@size.count-1) do
        a << [(@name.to_s+' - '+@size[i].to_s), @price[i],@img]
      end
    end
  end
end

class All_products

  def initialize (url, file_name)
    @url = url

    @file_name= file_name

  end

  def products_list
    puts 'Начал'
    @number_page = 2
    @page = ''
    @full_list= []
    @n= 1
    CSV.open(@file_name+".csv","w") do |wr|
      wr << ["Name", "price", "image"]
    end
    @threads = []
    while Curl::Easy.perform(@url + @page).status.to_s == '200'
      @doc = Nokogiri::HTML ((Curl::Easy.perform(@url + @page)).body_str)

      @page = '?p=' + @number_page.to_s
      @number_page = @number_page + 1
      @links = @doc.xpath("//div[@class='product-desc display_sd']/a/@href")
      @full_list += @links # list with all url
      for @link in @links
        Product.new(@link).get_info (@file_name)
        puts 'Выполняю ', @link
      end
    end
  end
end

url_page = 'https://www.petsonic.com/comida-lata-para-perros/' #exemple

puts "Enter URL"
url_page = gets.chomp

puts "Enter File name"
file_name = gets.chomp

prod = All_products.new(url_page, file_name)
prod.products_list
