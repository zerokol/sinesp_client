require "sinesp_client/version"
require 'openssl'
require 'httparty'
require 'securerandom'


module SinespClient

  include HTTParty

  default_options.update(verify: false)

  def self.lat
    rand(-90.000000000...90.000000000)
  end

  def self.long
    rand(-180.000000000...180.000000000)
  end

  def self.search(plate)

    key = "#8.1.0#g8LzUadkEHs7mbRqbX5l"
    digest = OpenSSL::Digest.new('sha1')
    hash = OpenSSL::HMAC.hexdigest(digest, plate + key, plate)

    body = "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\" ?>
      <v:Envelope xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\">
      <v:Header>
        <b>samsung GT-I9192</b>
        <c>ANDROID</c>
        <d>8.1.0</d>
        <i>#{lat}</i>
        <e>4.1.5</e>
        <f>10.0.0.1</f>
        <g>#{hash}</g>
        <k></k>
        <h>#{long}</h>
        <l>#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}</l>
        <m>8797e74f0d6eb7b1ff3dc114d4aa12d3</m>
      </v:Header>
      <v:Body>
        <n0:getStatus xmlns:n0=\"http://soap.ws.placa.service.sinesp.serpro.gov.br/\">
          <a>#{plate}</a>
        </n0:getStatus>
      </v:Body>
    </v:Envelope>"

    headers = {
      'Content-type' => 'application/x-www-form-urlencoded; charset=UTF-8',
      'Accept' => 'text/plain, */*; q=0.01',
      'Cache-Control' => 'no-cache',
      'Pragma' => 'no-cache',
      'Content-length' => body.length.to_s,
      'User-Agent' => 'SinespCidadao/4.2.3 CFNetwork/808.1.4 Darwin/16.1.0'
    }

    #begin

    response = post("https://cidadao.sinesp.gov.br/sinesp-cidadao/mobile/consultar-placa/v4", body: body, headers: headers, timeout: 20)

    #rescue
    #  return nil
    #end

    #If the query is valid, "codigoRetorno" will be 0. Otherwise something went wrong. Just return nil.
    # if parsed_response[:codigoRetorno] == "0"
    response["Envelope"]["Body"]["getStatusResponse"]["return"]
    # else
    #   nil
    # end

  end

end
