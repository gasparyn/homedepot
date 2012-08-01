class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :name,:quantity
  
  
  validates :description, :image_url, :price, :name, :presence =>true
  validates :price, :numericality =>{:greater_than_or_equal_to => 0.01}
  validates :name,:uniqueness =>true
  
  validates :image_url, :format => {
                              :with    => %r{\.(gif|jpg|png)$}i,
                              :message => 'must be a URL for GIF, JPG or PNG image.'
                            }
  default_scope :order => 'name'                          
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  
  private
  
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base,'line Items Present')
        return false
      end
    end
  
end
