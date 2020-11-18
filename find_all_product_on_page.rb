require 'curb'
require 'nokogiri'
require 'csv'
url_page='https://www.petsonic.com/comida-lata-para-perros/'
file_name=gets.chomp()
status=true#станет false, когда не найдет на странице текст "следующая стр"
number_page=2
page=''
full_list=[]
while status # понимаю насколько это медленно и глупо, но пока другой алгоритм не подобрал
  url=url_page+page
  c = Curl::Easy.perform(url)
  doc = Nokogiri::HTML(c.body_str)
  kol_vo=doc.xpath("//button[@class='loadMore next button lnk_view btn btn-default']/span/text()").count
  if kol_vo==1
    page='?p='+number_page.to_s
    number_page=number_page+1
    links=doc.xpath("//div[@class='product-desc display_sd']/a/@href")
    full_list+=links
  else
    status=false
  end
end# ооооооочень долгая конструкция, оптимизирую ее первым делом(если этот комент висит, значит не опитимизировал((()
puts 'Нашел список всех продуктов. Я насчитал '+ full_list.count.to_s

CSV.open(file_name+".csv","w") do |wr|
  wr << ["Name", "price", "image"]
end

iskl=[]
for i in full_list
  url=i
  c = Curl::Easy.perform(url)
  doc = Nokogiri::HTML(c.body_str)
  puts 'Записываю данные с '+i
  img=doc.xpath("//span[@id='view_full_size']/img/@src")
  name=doc.xpath("//h1/text()")
  size=doc.xpath("//label/span[@class='radio_label']/text()")
  price=doc.xpath("//label/span[@class='price_comb']/text()")

  CSV.open(file_name+".csv","a") do |a|
    for i in 0..(size.count-1) do
      a << [(name.to_s+' - '+size[i].to_s), price[i],img]
    end
  end
end
puts "Файл "+ file_name+'записан.'
