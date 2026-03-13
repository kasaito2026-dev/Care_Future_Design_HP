class Seminar < ApplicationRecord
  belongs_to :seminar_category, optional: true

  validates :title, presence: true
  validates :seminar_date, presence: true
  validates :seminar_category_id, presence: true
  validates :capacity, presence: true
  validates :location, presence: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "は半角英数字とハイフンのみ使用可能です" }
  validates :description, presence: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }
  before_validation :set_default_published

  scope :published, -> { where(is_published: true) }
  scope :upcoming, -> { where("seminar_date >= ?", Date.current).order(seminar_date: :asc) }
  scope :past, -> { where("seminar_date < ?", Date.current).order(seminar_date: :desc) }

  def to_param
    slug
  end

  def upcoming?
    seminar_date.present? && seminar_date >= Date.current
  end

  private

  def generate_slug
    base_slug = title.parameterize
    base_slug = "seminar-#{SecureRandom.hex(4)}" if base_slug.blank?
    self.slug = base_slug
  end

  def set_default_published
    self.is_published = true if self.is_published.nil?
  end
end
