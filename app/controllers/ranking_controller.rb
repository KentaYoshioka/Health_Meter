class RankingController < ApplicationController
  def index
    @performers = Performer.all.map do |performer|
      stats = performer.calculate_statistics
      next unless stats
      {
        id: performer.id,
        name: performer.name,
        latest_performance_date: stats[:latest_performance_date],
        low_z_count: stats[:low_z_count],
        z_scores: stats[:z_scores]
      }
    end.compact

    @performers ||= []
  end
end
