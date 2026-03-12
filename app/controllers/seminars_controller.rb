class SeminarsController < ApplicationController
  def index
    @categories = SeminarCategory.order(:name)
    @seminars = Seminar.published.includes(:seminar_category).order(seminar_date: :asc)
    set_meta_tags title: 'セミナー紹介', description: '介護技術・IT活用・経営の3ジャンルのセミナーをご用意しています。'
  end

  def show
    @seminar = Seminar.published.find_by!(slug: params[:slug])
    set_meta_tags title: @seminar.title
  end

  def category
    @category = SeminarCategory.find_by!(slug: params[:slug])
    @seminars = @category.seminars.published.order(seminar_date: :asc)
    set_meta_tags title: "#{@category.name} セミナー一覧"
  end

  # JSON API for calendar
  def calendar_events
    events = Seminar.published.where.not(seminar_date: nil).map do |s|
      { date: s.seminar_date.to_s, title: s.title, url: seminar_path(slug: s.slug) }
    end
    render json: events
  end
end
