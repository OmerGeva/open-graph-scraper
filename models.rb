class Domain < ActiveRecord::Base
  has_many :tags

  validates :url, presence: true, uniqueness: true

  after_commit :set_name, on: :create

  private

  def set_name
    self.name = url.split('www.', 2)[1].split('.com', 2)[0]
    save
  end
end

class Tag < ActiveRecord::Base
  belongs_to :domain

  validates :og_type, presence: true
  validates :content, presence: true
end
