module TiaCrawler
  class Timetable
    attr_accessor :seg, :ter, :qua, :qui, :sex, :sab
    
    def initialize
      @seg = []
      @ter = []
      @qua = []
      @qui = []
      @sex = []
      @sab = []
    end

    def append(dayString, val)
      if dayString == "Segunda"
        @seg << val
      elsif dayString == "Terça"
        @ter << val
      elsif dayString == "Quarta"
        @qua << val
      elsif dayString == "Quinta"
        @qui << val
      elsif dayString == "Sexta"
        @sex << val
      elsif dayString == "Sábado"
        @sab << val
      else
        puts "Failed to append"
      end
    end

    def as_json
      return {
        "seg" => @seg,
        "ter" => @ter,
        "qua" => @qua,
        "qui" => @qui,
        "sex" => @sex,
        "sab" => @sab
      }
    end
  end
end
