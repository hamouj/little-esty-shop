class HolidaySearch 
  def service
    HolidayService.new
  end

  def upcoming_holidays
    all_upcoming_holidays = service.upcoming_holidays.map do |data|
      Holiday.new(data)
    end

    all_upcoming_holidays.first(3)
  end
end