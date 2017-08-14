#!/usr/bin/env ruby
require 'thor'
require_relative 'tia/services/tia-service'
require_relative 'tia/models/credentials'

module TiaCrawler
  class CLI < Thor
    desc 'horarios', 'Retorna a lista de horarios em formato JSON'
    def horarios
      print "Tia: "
      alumat = STDIN.gets.chomp

      print "Senha: "
      password = STDIN.noecho(&:gets)

      puts "\nCrawling horarios..."

      credentials = Credentials.new alumat, password, '001'
      puts TiaService.horarios credentials
    end
  end
end
