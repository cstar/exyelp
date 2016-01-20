defmodule Exyelp do

  alias Exyelp.Search

  def start do
    Search.start
 end

  def search(params, creds) do
      url = build_url(params)
      Search.get!(url, [signed_header(url, creds)]).body
  end

  def phone_search(phone, country, creds) do
      url = build_url(%{phone: phone, CC: country},  "https://api.yelp.com/v2/phone_search")
      Search.get!(url, [signed_header(url, creds)]).body
  end

  def signed_header(url, creds) do
      oauth_creds = OAuther.credentials(creds)
      signed_params = OAuther.sign("GET", url, [], oauth_creds)
      {signed_header, _req_params} = OAuther.header(signed_params)
      signed_header
  end 

  def build_url(params) do
    build_url(params, "https://api.yelp.com/v2/search")
  end

  def build_url(params, baseuri) do
    uri = URI.parse(baseuri)
    to_string(%{uri | query: URI.encode_query(params)})
  end

end
