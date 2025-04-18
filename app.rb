require "sinatra"
require "sinatra/reloader"
require "dotenv/load"
require "http"
require "json"

get("/") do
  
  exchange_list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("X_KEY")}"
  raw_response_list = HTTP.get(exchange_list_url)
  parsed_list = JSON.parse(raw_response_list)
  currencies_hash = parsed_list.fetch("currencies")
  @currencies_list = currencies_hash.keys
 
  erb(:homepage)
end

get ("/:from_currency") do
  @original_currency = params.fetch("from_currency")
  exchange_list_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("X_KEY")}"
  raw_response_list = HTTP.get(exchange_list_url)
  parsed_list = JSON.parse(raw_response_list)
  currencies_hash = parsed_list.fetch("currencies")
  @currencies_list = currencies_hash.keys

   erb(:from_currency)
end

get ("/:from_currency/:to_currency") do
  @original_currency = params.fetch("from_currency")
  @new_currency = params.fetch("to_currency")
  exchange_rate_url = "https://api.exchangerate.host/convert?from=#{@original_currency}&to=#{@new_currency}&amount=1&access_key=#{ENV.fetch("X_KEY")}"
  rate_response = HTTP.get(exchange_rate_url)
  @parsed_rate = JSON.parse(rate_response).fetch("result")


  erb(:to_currency)
end
