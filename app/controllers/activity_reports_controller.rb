class ActivityReportsController < ApplicationController
  def index
    @reports = ActivityReport.published.order(published_at: :desc).limit(20)
  end

  def show
    @report = ActivityReport.published.find_by!(slug: params[:slug])
  end
end
