require 'io/console'
require 'net/http'
require 'uri'
require 'nokogiri'

require_relative '../models/tia-url'
require_relative '../models/subject'
require_relative '../models/timetable'
require_relative 'networking'

module TiaCrawler
  class TiaService
    def self.getAuthCookie(credentials)
      token, cookie = TiaService.get_login_token_and_cookie
      newCookie = TiaService.authenticate credentials, token, cookie

      # ???
      theCookie = "tiaMackenzieWeb=a%3A2%3A%7Bs%3A4%3A%22user%22%3BN%3Bs%3A6%3A%22passwd%22%3BN%3B%7D; #{newCookie}"

      return theCookie
    end

    # Entra na página de login do tia para pegar
    # o token e o cookie necessários para o login
    def self.get_login_token_and_cookie
      begin
        # Entra na página de login do TIA
        uri = URI.parse TiaURL::Login
        response = Net::HTTP.get_response uri

        # Guarda o cookie recebido na resposta HTTP (PHPSESSID)
        cookie = response['set-cookie'].split('; ')[0]

        # Guarda o token que está no formulário de login, dentro da página
        nokogiriHTML = Nokogiri::HTML response.body
        token = nokogiriHTML.css('[name="token"]')[0]['value']

        return {token: token, cookie: cookie}
      rescue Exception => e
        puts "❗️ Failed!"
        puts e
      end
    end

    # Atentica e retorna o cookie da autenticação
    def self.authenticate(credentials, token, cookie)
      # Cabeçalho da requisição HTTP para autenticação
      headers =
      {
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Cookie' => "#{cookie}",
        'Referer' => TiaURL::Login
      }

      # Corpo da requisição HTTP para autenticação
      body = {
        token: token,
        alumat: credentials.tia,
        pass: credentials.password,
        unidade: credentials.unit
      }

      # Pega a resposta do POST request do formulário de autenticação
      res = Networking.post TiaURL::Auth, headers, body, true

      # Pega o novo cookie no header da resposta HTTP
      # O novo cookie é o que precisa ser usado para fazer os próximos requests
      newCookie = res['set-cookie'].split('; ')[0]

      return newCookie
    end

    def self.home(credentials)
      cookie = TiaService.getAuthCookie credentials
      # Cabeçalho da requisição HTTP para autenticação
      headers =
      {
        'Cookie' => cookie,
        'Referer' => TiaURL::Auth
      }

      res = Networking.post TiaURL::Home, headers, nil, true
      nokogiriHTML = Nokogiri::HTML res.body

      tia, name = nokogiriHTML.css('center h2').inner_html.split(' - ')
      subject = nokogiriHTML.css('center h3')
      puts "#{tia} - #{name}"
      puts "#{subject}"

      return nokogiriHTML
    end

    def self.jsonSubjects(html)
      tables = html.css('.table-responsive')

      theSubjects = {}

      dias = []

      header = tables[0].css('tr')[0].css('strong')
      header[1...header.size].each do |d|
        dias << d.inner_html
      end

      tables.each_with_index do |table, i|
        rows = table.css('tr')
        rows[1...rows.size].each_with_index do |row, j|
          cols = row.css('td div')
          cols[1...cols.size].each do |c|
            items = c.inner_html.split('<br>')
            name = items[0].strip
            classid = items[1]
            building = items[2]
            classroom = items[3]

            if name != "--"
              dia = dias[j]

              theSubjects[name] = Subject.new name if theSubjects[name].nil?
              theSubjects[name].timetable.append dia, cols[0].inner_html
            end
          end
        end
      end

      json = []
      theSubjects.each do |key, val|
        json << val.as_json
      end

      return json
    end

    def self.horarios(credentials)
      cookie = TiaService.getAuthCookie credentials
      # Cabeçalho da requisição HTTP para autenticação
      headers =
      {
        'Cookie' => cookie,
        'Referer' => TiaURL::Home
      }

      res = Networking.post TiaURL::Horarios, headers, nil, true
      nokogiriHTML = Nokogiri::HTML res.body

      return TiaService.jsonSubjects nokogiriHTML
    end
  end
end
