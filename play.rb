require 'open-uri'
require 'json'
require 'time'
require 'date'
require 'pp'

START = { name: "Berlin",  apc: "TXL", cc: "DE" }

PLACES = [
  { name: "Barcelona",  apc: "BCN", cc: "SP" },
  { name: "Budapest",   apc: "BUD", cc: "HU" },
  { name: "Cologne",    apc: "CGN", cc: "DE" },
  { name: "Copenhagen", apc: "CPH", cc: "DK" },
  { name: "Dresden",    apc: "DRS", cc: "DE" },
  { name: "Frankfurt",  apc: "FRA", cc: "DE" },
  { name: "Madrid",     apc: "MAD", cc: "SP" },
  { name: "Moscow",     apc: "DME", cc: "RU" },
  { name: "Paris",      apc: "CDG", cc: "FR" },
  { name: "Prague",     apc: "PRG", cc: "CZ" },
  { name: "Sofia",      apc: "SOF", cc: "BG" },
  { name: "Tel Aviv",   apc: "TLV", cc: "IS" },
  { name: "Vienna",     apc: "VIE", cc: "AU" },
]

HOTELS = JSON.parse(File.read('hotels.json'))



def date_of_next(day)
  date = Date.parse(day)
  date + date > Date.today ? 0 : 7
end

def fetch(path)
  raw = open("https://app.xapix.io/api/v1/#{path}", 'Authorization' => 'ab16_weekendout:dC1pVEX1eDTy8Bq22Z0sUIkJa3vN5O8S', 'Accept' => 'application/json').read
  dat = JSON.parse(raw)
  dat[dat.keys.first]
end

# [{
#   "destination": "ACE",
#   "departure": "TXL",
#   "random_id": "648085200358887372",
#   "previous_outbound_flight_date": "2016-12-03",
#   "next_outbound_flight_date": "2016-12-06"
# }]
def flights(from, to, date = nil)
  date ||= date_of_next('friday').strftime('%Y-%m-%d')
  from.upcase!
  to.upcase!
  date = Time.parse(date).strftime('%Y-%m-%d')
  fetch "airberlin_lab_2016/availabilities?filter%5Bdeparture%5D=#{from}&filter%5Bdestination%5D=#{to}&filter%5Bflightdate%5D=#{date}&fields%5Bavailabilities%5D=destination%2Cdeparture%2Crandom_id%2Cprevious_outbound_flight_date%2Cnext_outbound_flight_date&sort=random_id&page%5Bnumber%5D=1&page%5Bsize%5D=100"
end

def find_flights(date = nil)
  PLACES.map { |place|
    puts place[:name]
    flights(START[:apc], place[:apc], date)
  }.flatten
end

pp find_flights('2016-12-09')


# [{
#   "name": "Aalborg",
#   "longitude": "9.85",
#   "country_code": "DK",
#   "city_code": "AAL",
#   "latitude": "57.09305556",
#   "code": "AAL"
# }]
def airports
  fetch 'airberlin_lab_2016/airports?fields%5Bairports%5D=name%2Clongitude%2Ccountry_code%2Ccity_code%2Clatitude%2Ccode&sort=code&page%5Bnumber%5D=1&page%5Bsize%5D=1000'
end



# def station_pairs
#   url = 'https://xap.ix-io.net/api/v1/distribusion/service_features?filter%5Bprovider_id%5D=425&fields%5Bservice_features%5D=provider_id%2Cfeature_type%2Cfeature_asset_name%2Cfeature_tooltip%2Cfeature_name%2Cx_id%2Ctype&sort=x_id&page%5Bnumber%5D=1&page%5Bsize%5D=1000'
#   JSON.parse(`curl -H 'Authorization: #{AUTH_KEY}' -H 'Accept: application/json' '#{url}'`)['station_pairs']
# end

def stations(country_code, city)
  country_code.upcase!
  fetch "distribusion/stations?filter%5Bcountry_code%5D=#{country_code}&filter%5Bcity_name%5D=#{city}&fields%5Bstations%5D=iata_code%2Ctime_zone%2Ccountry_code%2Ccity_name%2Clongitude%2Clatitude%2Cname%2Cx_id&sort=x_id&page%5Bnumber%5D=1&page%5Bsize%5D=100"
end

#pp stations('DE', 'Berlin')

# {
#   "station_pairs": [
#     {
#       "departure_station_id": "2025",
#       "arrival_station_id": "11069",
#       "random_id": "00003ad4-714d-4dba-8c07-4b57250680f1"
#     },


# {
#   "place_translations": [
#     {
#       "type": "translations",
#       "place_id": "11069",
#       "comment": "Die Haltestelle befindet sich am Busbahnhof.",
#       "name": "Graz ZOB",
#       "locale": "de",
#       "x_id": "11671"
#     },
#     {
#       "type": "translations",
#       "place_id": "11069",
#       "comment": "The bus stop is located at the bus station.",
#       "name": "Graz Central Bus Station",
#       "locale": "en",
#       "x_id": "23359"
#     },
#     {
#       "type": "translations",
#       "place_id": "11069",
#       "comment": null,
#       "name": null,
#       "locale": "it",
#       "x_id": "27823"
#     },
#     {
#       "type": "translations",
#       "place_id": "11069",
#       "comment": null,
#       "name": null,
#       "locale": "pl",
#       "x_id": "27825"
#     }
#   ]
# }


# {
#   "arrival_station_names": [
#     {
#       "type": "arrival_station_names",
#       "station_name": "Amsterdam Duivendrecht",
#       "x_id": "10065"
#     },



# {
#   "providers": [
#     {
#       "display_name": "Postbus",
#       "customer_booking_fee_in_cents": "0",
#       "x_id": "129"
#     },
#


