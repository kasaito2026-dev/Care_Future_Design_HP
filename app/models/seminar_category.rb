class SeminarCategory < ApplicationRecord
  has_many :seminars, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9\-]+\z/, message: "は半角英数字とハイフンのみ使用可能です" }

  def to_param
    slug
  end
end
