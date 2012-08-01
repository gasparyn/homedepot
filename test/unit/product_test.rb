require 'test_helper'

class ProductTest < ActiveSupport::TestCase
 test "product attributes must not be empty"
    product =Product.new
    assert product.invalid?
    assert product.errors[:name].any?
    assert product.errors[:description].any?
    assert products.errors[:price].any?
    assert products.errors[:image_url].any?
    
end
