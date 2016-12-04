require 'sinatra'
require 'thin'
require 'json'
require 'time'
require 'date'
require 'open-uri'

set server: 'thin', bind: '127.0.0.1', port: 8080, public_folder: File.join(File.dirname(__FILE__), 'public')
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'super_secret_123'

PLACES = [
  { name: "Barcelona",  apc: "BCN", cc: "SP", lat: 41.387917, lon: 2.1699187, beach: true,  mountain: true },
  { name: "Budapest",   apc: "BUD", cc: "HU", lat: 47.498400, lon: 19.040800, beach: false, mountain: false },
  { name: "Cologne",    apc: "CGN", cc: "DE", lat: 45.578620, lon: 9.9418000, beach: false, mountain: false },
  { name: "Copenhagen", apc: "CPH", cc: "DK", lat: 55.676097, lon: 12.568337, beach: true,  mountain: false },
  { name: "Dresden",    apc: "DRS", cc: "DE", lat: 51.050409, lon: 13.737262, beach: false, mountain: false },
  { name: "Frankfurt",  apc: "FRA", cc: "DE", lat: 50.110922, lon: 8.6821270, beach: false, mountain: false },
  { name: "Madrid",     apc: "MAD", cc: "SP", lat: 40.416775, lon: -3.703790, beach: false, mountain: false },
  { name: "Moscow",     apc: "DME", cc: "RU", lat: 55.755826, lon: 37.617300, beach: false, mountain: false },
  { name: "Paris",      apc: "CDG", cc: "FR", lat: 48.856614, lon: 2.3522220, beach: false, mountain: false },
  { name: "Prague",     apc: "PRG", cc: "CZ", lat: 50.075538, lon: 14.437800, beach: false, mountain: false },
  { name: "Sofia",      apc: "SOF", cc: "BG", lat: 42.697708, lon: 23.321868, beach: false, mountain: true },
  { name: "Tel Aviv",   apc: "TLV", cc: "IS", lat: 32.085300, lon: 34.781768, beach: true,  mountain: false },
  { name: "Vienna",     apc: "VIE", cc: "AU", lat: 48.208174, lon: 16.373819, beach: false, mountain: true },
]

def generate_hotel(days=2, city=nil)
  city = city.split.map(&:capitalize).join(' ') if city
  place = PLACES.find { |e| e[:name].downcase == city.to_s.downcase }
  pre = ['Excelsior', 'Grand', 'Superior', 'Mandarin', 'Westin', 'Amman', 'Grand', 'White', 'Hyatt']
  post = ['Resort', 'Hotel', 'Lodge', 'Inn', 'Oriental', 'Palais', 'Imperial', 'Manor']
  city_mid = city if rand < 0.3
  name = [(pre.sample if rand < 0.8), city_mid, (post.sample if rand < 0.8), ((rand < 0.3 ? city : nil) unless city_mid)].compact.join(' ')
  name << " #{post.sample}" if name == city
  hotel = { name: name, price: rand(22..79) * days }
  hotel.merge!(lat: place[:lat]+rand(-0.4..0.4), lon: place[:lat]+rand(-0.4..0.4), airport: place[:apc]) if place
  hotel
end

def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end

def generate_time_set(date, duration=2)
  date = Time.parse(date.to_s).strftime('%Y-%m-%d')
  s = Time.parse("#{date} #{rand(6..22)}:#{rand(0..59)}")
  [s, s+duration*3600+rand(-1200..1200)].map(&:iso8601)
end

def generate_transport(date_from=nil, date_to=nil, type=:flight)
  date_from ||= date_of_next('friday')
  date_to ||= date_from + 3600*48
  ts1 = generate_time_set(date_from, rand(2..4))
  ts2 = generate_time_set(date_to, rand(2..4))
  to = PLACES.sample[:name]
  {
    outward: {from: 'Berlin', to: to, departure: ts1.first, arrival: ts1.last},
    inward: {from: to, to: 'Berlin', departure: ts2.first, arrival: ts2.last},
    price: type == :flight ? rand(39..179) : rand(12..39),
    transport: type == :flight ? 'AirBerlin' : ['FlixBus', 'MeinFernbus'].sample
  }
end

def fetch(path)
  raw = open("https://app.xapix.io/api/v1/#{path}", 'Authorization' => 'ab16_weekendout:dC1pVEX1eDTy8Bq22Z0sUIkJa3vN5O8S', 'Accept' => 'application/json').read
  dat = JSON.parse(raw)
  dat[dat.keys.first]
end

def airport_info(apc)
  fetch("airberlin_lab_2016/airports/#{apc.upcase}?fields%5Bairports%5D=name%2Clongitude%2Ccountry_code%2Ccity_code%2Clatitude%2Ccode")
end

def reachable_airports_from(apc='TXL')
  routes = fetch("airberlin_lab_2016/destination_routes?filter%5Bdeparture%5D=#{apc.upcase}&fields%5Bdestination_routes%5D=departure%2Cend_date%2Cstart_date%2Ciata_code&sort=iata_code&page%5Bnumber%5D=1&page%5Bsize%5D=100")
  routes.map { |r| r['iata_code'] }.uniq.map { |c| (airport_info(c) rescue nil) }.compact
end

get '/airports_from/:apc/?' do
  reachable_airports_from(params[:apc]).to_json
end

get '/hotels/:city/?' do
  Array.new(rand(3..9)) { generate_hotel(1, params[:city]) }.to_json
end

get '/trips/?' do
  d1 = Time.parse(params[:date_from] || date_of_next('friday').strftime('%Y-%m-%d')).strftime('%Y-%m-%d')
  d2 = Time.parse(params[:date_to]   || (Time.parse(d1) + 3600*48).strftime('%Y-%m-%d')).strftime('%Y-%m-%d')
  days = (Date.parse(d2) - Date.parse(d1)).to_i
  Array.new(rand(3..12)) {
    t = generate_transport(d1, d2, rand < 0.3 ? :bus : :flight)
    h = generate_hotel(days, PLACES.sample[:name])
    {
      transport: t,
      hotel: h,
      total_price: h[:price] + t[:price]
    }
  }.to_json
end
