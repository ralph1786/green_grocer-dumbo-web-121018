require "pry"

def consolidate_cart(cart)
  cart.each_with_object({}) do |item, result|
    item.each do |type, attributes|
      if result[type]
        attributes[:count] += 1
      else
        attributes[:count] = 1
        result[type] = attributes
      end
      # binding.pry
    end
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    product_name = coupon[:item]
    if cart[product_name] && cart[product_name][:count] >= coupon[:num]
      if cart["#{product_name} W/COUPON"]
        cart["#{product_name} W/COUPON"][:count] += 1
      else
        cart["#{product_name} W/COUPON"] = {:count => 1, :price => coupon[:cost]}
        cart["#{product_name} W/COUPON"][:clearance] = cart[product_name][:clearance]
      end
      cart[product_name][:count] -= coupon[:num]
    end
    # binding.pry
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, product_props|
    if product_props[:clearance]
      discounted_price = product_props[:price] * 0.80
      product_props[:price] = discounted_price.round(2)
    end
    # binding.pry
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(couponed_cart)
  # binding.pry
  total = 0
  final_cart.each do |product_name, product_props|
    # binding.pry
    total += product_props[:price] * product_props[:count]
  end
  total = total * 0.9 if total > 100
  total
  # binding.pry
end
