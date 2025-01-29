require 'http'
class HomeController < ApplicationController
  def index
    @temperature = fetch_temperature
    @unhealthy_count = Performer.all.map { |performer| performer.calculate_statistics }.compact.count do |stats|
      stats[:low_z_count] > 5
    end
    @top_performers = Performer.limit(3).map do |performer|
    stats = performer.calculate_statistics
    next unless stats
    {
      name: performer.name,
      latest_performance_date: stats[:latest_performance_date],
      low_z_count: stats[:low_z_count]
    }
    end.compact
    @unhealthy_performers = Performer.all.map do |performer|
    stats = performer.calculate_statistics
    next unless stats
    {
      name: performer.name,
      low_z_count: stats[:low_z_count]
    }
    end.compact
    @unhealthy_performers = @unhealthy_performers.sort_by { |performer| -performer[:low_z_count] }.first(3)

    @healthy_ranking = Performer.all.map do |performer|
    latest_performance = performer.performances.order(date: :desc).first
    next unless latest_performance
    activities = latest_performance.activities
    next if activities.empty?        
    avg_value = activities.map(&:value).sum / activities.size.to_f
    {
      name: performer.name,
      average_value: avg_value.round(2)        }
    end.compact
      @healthy_ranking.sort_by! { |performer| -performer[:average_value] }
  end

  private
  def fetch_temperature
    api_key = "72f099fd0cdb2144aa52642fd3be6b81"
    city = "Tokyo"
    url = "https://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric&appid=#{api_key}"
    begin
      response = HTTP.get(url)
      if response.status.success?
        data = JSON.parse(response.body.to_s)
        temp = data.dig("main", "temp") # 現在の気温
        Rails.logger.info("Fetched temperature: #{temp}")
        temp
      else
        Rails.logger.error("Failed to fetch temperature: #{response.status}")
        nil
      end
    rescue => e
      Rails.logger.error("Error fetching temperature: #{e.message}")
      nil
    end
  end
end

