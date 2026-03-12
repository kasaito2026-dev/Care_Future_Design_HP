class Admin::SeminarsController < Admin::BaseController
  before_action :set_seminar, only: [:edit, :update, :destroy]

  def index
    @seminars = Seminar.includes(:seminar_category).order(created_at: :desc)
  end

  def new
    @seminar = Seminar.new
  end

  def create
    @seminar = Seminar.new(seminar_params)
    if @seminar.save
      redirect_to admin_seminars_path, notice: "セミナーを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @seminar.update(seminar_params)
      redirect_to admin_seminars_path, notice: "セミナーを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @seminar.destroy
    redirect_to admin_seminars_path, notice: "セミナーを削除しました"
  end

  private

  def set_seminar
    @seminar = Seminar.find_by!(slug: params[:id])
  end

  def seminar_params
    params.require(:seminar).permit(
      :title, :slug, :description, :seminar_date,
      :location, :capacity, :seminar_category_id, :is_published
    )
  end
end
