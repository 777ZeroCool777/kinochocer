# encoding: utf-8
# Программа, которая выберает фильм для просмотра

# /XX Этот код неообходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XX


require 'mechanize'
require 'launchy' # этот гем необходим, что бы открыть сайт в браузере


agent = Mechanize.new()

chosen = false

until chosen
  begin
  page = agent.get("http://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/perpage/100/page/#{rand(5) }/")
  rescue SocketError, Net::HTTP::Persistent::Error # если нет сети
    abort "Не удалось добраться до кинопоиска :( Проверьте сеть"
  end

  tr_tag = page.search("//tr[starts-with(@id, 'tr_')]").to_a.sample

  kino_title = tr_tag.search("a[@class='all']").text
  kinopoisk_rating = tr_tag.search("span[@class = 'all']").text
  id = tr_tag.attributes['id'].to_s
  i = id.delete("tr_")
  kinopoisk_link = "www.kinopoisk.ru/film/#{i}/"
  film_description = tr_tag.search("span[@class='gray_text']")[0].text

  # Вывожу случайный фильм
  puts kino_title
  puts film_description
  puts "Рейтинг кинопоиска: #{kinopoisk_rating}"

  puts "Смотрим?(Y/N)"

  choice = STDIN.gets.chomp

  if choice.downcase == "y"
    chosen = true
    Launchy.open(kinopoisk_link) # открываю фильм в браузере

  end
end