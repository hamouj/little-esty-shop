# require 'httparty'

class HolidayService
  def upcoming_holidays
    get_url('https://date.nager.at/api/v3/NextPublicHolidays/US')
  end

  def get_url(url)
    response = HTTParty.get(url)
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end