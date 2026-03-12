class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = SeminarCategory.order(:name)
  end

  def new
    @category = SeminarCategory.new
  end

  def create
    @category = SeminarCategory.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "カテゴリを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: "カテゴリを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: "カテゴリを削除しました"
  end

  private

  def set_category
    @category = SeminarCategory.find_by!(slug: params[:id])
  end

  def category_params
    params.require(:seminar_category).permit(:name, :slug, :description, :color)
  end
end
