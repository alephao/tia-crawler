require_relative './timetable'

module TiaCrawler
  class Subject
    attr_accessor :name, :timetable

    def initialize(name)
      @name = name
      @timetable = Timetable.new
    end

    def as_json
      return {
        "name" => @name,
        "timetable" => @timetable.as_json,
      }
    end
  end
end
