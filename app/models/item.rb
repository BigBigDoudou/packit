class Item < ApplicationRecord

  # ASSOCIATIONS

  belongs_to :user
  belongs_to :reference, class_name: 'ItemReference'
  has_many :packed_items, dependent: :destroy

  # SCOPES

  scope :category, -> (category, user) {
    joins(:reference)
    .where(item_references: { category_id: category })
    .joins(:user)
    .where(users: { id: user })
    .order(created_at: :desc)
  }
  scope :packed, -> (packed_bag) {
    joins(:packed_items)
    .where(packed_items: { packed_bag_id: packed_bag })
  }

  # VALIDATIONS

  validates :size, numericality: { greater_than: 0, less_than_or_equal_to: 99.99 }
  validates :weight, numericality: { greater_than: 0, less_than_or_equal_to: 99.99 }

  # CALLBACKS

  before_create :set_size, :set_weight

  # METHODS

  def name
    self.reference.name
  end

  def category
    self.reference.category
  end

  def picture
    self.reference.picture
  end

  def packed?(packed_bag)
    self.packed_items.where(packed_bag: packed_bag).any?
  end

  private

  def set_size
    self.size = self.reference.size if self.size.nil?
  end

  def set_weight
    self.weight = self.reference.weight if self.weight.nil?
  end
end
