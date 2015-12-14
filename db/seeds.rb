# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

module CityDataGenerater
  PATTERN = /(\d{2})(\d{2})(\d{2})/

  class << self
    def match(code)
      code.match(PATTERN)
    end

    def province(code)
      match(code)[1].ljust(6, '0')
    end

    def city(code)
      id_match = match(code)
      "#{id_match[1]}#{id_match[2]}".ljust(6, '0')
    end

    def data
      unless @list
        #{ '440000' =>
        #  {
        #    :text => '广东',
        #    :children =>
        #      {
        #        '440300' =>
        #          {
        #            :text => '深圳',
        #            :children =>
        #              {
        #                '440305' => { :text => '南山' }
        #              }
        #           }
        #       }
        #   }
        # }
        @list = {}
        #@see: http://github.com/RobinQu/LocationSelect-Plugin/raw/master/areas_1.0.json
        @list = JSON.parse(File.read("#{Rails.root}/db/areas.json"))
      end
      @list
    end
  end

  class << self
    def load_state
      # 先清理了原有的
      State.destroy_all

      @states =[]
      # byebug
      data.fetch("province").each do |province|
        @states << {
            name: province.fetch("text"),
            code: province.fetch("id"),
        }
      end

      State.create!(@states)
    end

    def load_city
      @cities = []
      data.fetch("city").each do |city|
        # byebug
        code = city.fetch("id")
        province_code = province(code)
        province = Spree::State.find_by(abbr: province_code)

        @cities << {
            name: city.fetch("text"),
            code: code,
            state: province
        }
      end

      Spree::City.create!(@cities)
    end

    def load_districts
      @districts = []
      data.fetch("district").each do |district|
        code = district.fetch("id")
        city_code = city(code)
        city = ::Spree::City.find_by(code: city_code)

        @districts << {
            name: district.fetch("text"),
            code: code,
            city: city
        }
      end

      Spree::District.create!(@districts)
    end
  end
end

CityDataGenerater.load_state