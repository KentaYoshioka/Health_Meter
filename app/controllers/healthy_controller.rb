class HealthyController < ApplicationController
  def index
    @performers = Performer.all.map do |performer|
    latest_performance = performer.performances.order(date: :desc).first
    next unless latest_performance
    activities = latest_performance.activities
    next if activities.empty?
    avg_value = activities.map(&:value).sum / activities.size.to_f
    {
      name: performer.name,
      average_value: avg_value.round(2)
    }
    end.compact
    @performers.sort_by! { |performer| -performer[:average_value] }
  end
end

