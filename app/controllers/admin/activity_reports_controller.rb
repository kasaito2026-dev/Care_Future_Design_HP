class Admin::ActivityReportsController < Admin::BaseController
  before_action :set_report, only: [:edit, :update, :destroy]

  def index
    @reports = ActivityReport.order(created_at: :desc)
  end

  def new
    @report = ActivityReport.new
  end

  def create
    @report = ActivityReport.new(report_params)
    if @report.save
      redirect_to admin_activity_reports_path, notice: "活動報告を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @report.update(report_params)
      redirect_to admin_activity_reports_path, notice: "活動報告を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to admin_activity_reports_path, notice: "活動報告を削除しました"
  end

  private

  def set_report
    @report = ActivityReport.find(params[:id])
  end

  def report_params
    params.require(:activity_report).permit(
      :title, :slug, :content, :published_at, :is_published
    )
  end
end
