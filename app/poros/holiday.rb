class Holiday
  attr_reader :name, :date

  def initialize(data)
    @name = data[:name]
    @date = Date.parse(data[:date]).to_date.strftime("%A, %B %d, %Y")
  end
end