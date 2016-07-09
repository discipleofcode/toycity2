require 'json'
require 'artii'

path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

def print_ascii_art(text)
  a = Artii::Base.new
  puts a.asciify(text)
end

# print horizontal line
def print_hr(length = 20)
  puts "*" * length
end

def print_products_report(products_hash)
  products_hash["items"].each do |toy|
  
    name = toy["title"]
	price = toy["full-price"].to_f
	totalPurchases = toy["purchases"].length
	
	totalSales = toy["purchases"].inject(0) {|sum, purchase| sum + purchase["price"]}
	
	avgPrice = totalSales / totalPurchases
	avgDiscount = price - avgPrice
	avgDiscountPercentage = (avgDiscount / price) * 100
	
	### Displaying now
	
	puts
	puts name
    print_hr
	puts "Price: $" + price.to_s
	puts "Total purchases: " + totalPurchases.to_s
	puts "Total sales: $" + totalSales.to_s
	puts "Average price: $" + avgPrice.to_s
	puts "Average discount: $" + sprintf('%.2f', avgDiscount)
	puts "Average discount (percentage): " + sprintf('%.2f%', avgDiscountPercentage)
    print_hr

  end
end

def print_brands_report(products_hash)
  brands_hash = {}
  products_hash["items"].each do |toy|
    brands_hash[toy["brand"]] = 1
  end
  
  brands_hash.each do |name, brand|
	
	products = products_hash["items"].select{|toy| toy["brand"] == name}
	
	brandsToysStock = 0
	brandsPriceSum = 0
	brandsTotalSales = 0
	products.each do |product|
	  brandsToysStock += product["stock"]
	  brandsPriceSum += product["full-price"].to_f
	  
	  totalProductSales = product["purchases"].inject(0) {|sum, purchase| sum + purchase["price"]}
	  brandsTotalSales += totalProductSales
	end
	brandsAvgProductPrice = brandsPriceSum / products.length
	
	### Displaying now
	
	puts ""
	puts name
	puts "********************"
	puts "Number of Products: " + brandsToysStock.to_s
	puts "Average Product Price: $" + sprintf('%.2f', brandsAvgProductPrice)
	puts "Total Sales: $" + sprintf('%.2f', brandsTotalSales)
	
  end
end

# Print "Sales Report" in ascii art

print_ascii_art('Sales Report')

# Print today's date

time = Time.new
puts print_ascii_art(time.strftime("%d / %m / %Y"))

# Print "Products" in ascii art

print_ascii_art('Products')

# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

print_products_report(products_hash)	
	
# Print "Brands" in ascii art

print_ascii_art('Brands')

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

print_brands_report(products_hash)