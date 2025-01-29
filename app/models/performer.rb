class Performer < ApplicationRecord
  has_many :performances
  has_many :activities, through: :performances

  def calculate_statistics
    latest_performance = performances.order(date: :desc).first
    return nil unless latest_performance

    previous_activities = Activity.joins(:performance)
                                   .where(performances: { performer_id: id })
                                   .where.not(performance_id: latest_performance.id)

    stats = previous_activities.group_by(&:category).transform_values do |acts|
      values = acts.map(&:value)
      mean = values.sum.to_f / values.size
      stddev = Math.sqrt(values.map { |v| (v - mean)**2 }.sum / values.size)
      { avg_value: mean, stddev_value: stddev }
    end

    activities = latest_performance.activities

    z_scores = activities.map do |activity|
      stat = stats[activity.category]
      next unless stat && stat[:stddev_value] > 0
      z_score = (activity.value - stat[:avg_value]) / stat[:stddev_value]
      { category: activity.category, z_score: z_score }
    end.compact

    low_z_count = z_scores.count { |z| z[:z_score] <= -2.0 }

    {
      latest_performance_date: latest_performance.date,
      low_z_count: low_z_count,
      z_scores: z_scores
    }
  end
end
