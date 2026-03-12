class HomeController < ApplicationController
  def index
    @seminar_categories = SeminarCategory.order(:name)
    @recent_reports = ActivityReport.published.limit(4)
    set_meta_tags title: 'TOP', description: '介護職を、日本が誇る専門職として社会に確立する。介護従事者向けセミナー・IT導入支援・経営コンサルティング。'
  end
end
