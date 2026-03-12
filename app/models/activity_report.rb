class ActivityReport < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "は半角英数字とハイフンのみ使用可能です" }
  validates :content, presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  scope :published, -> { where(is_published: true).order(published_at: :desc) }

  def to_param
    slug
  end

  private

  def generate_slug
    base_slug = title.parameterize
    base_slug = "report-#{SecureRandom.hex(4)}" if base_slug.blank?
    self.slug = base_slug
  end
end
