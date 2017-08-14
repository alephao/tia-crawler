module TiaCrawler
  class Credentials
    attr_accessor :tia, :password, :unit
    def initialize(tia, pass, unit)
      @tia = tia
      @password = pass
      @unit = unit
    end
  end
end
