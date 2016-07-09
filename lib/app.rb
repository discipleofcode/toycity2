require 'json'
require 'artii'

path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

### common methods

def print_ascii_art(text)
  a = Artii::Base.new
  puts a.asciify(text)
end

# print horizontal line
def print_hr(length = 20)
  puts "*" * length
end

### end of common methods

### Products methods

def print_products_report(name, price, totalPurchases, totalSales, avgPrice, avgDiscount, avgDiscountPercentage)
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

def generate_products_report(products_hash)
  products_hash["items"].each do |toy|
  
    name = toy["title"]
	price = toy["full-price"].to_f
	totalPurchases = toy["purchases"].length
	
	totalSales = toy["purchases"].inject(0) {|sum, purchase| sum + purchase["price"]}
	
	avgPrice = totalSales / totalPurchases
	avgDiscount = price - avgPrice
	avgDiscountPercentage = (avgDiscount / price) * 100
	
    print_products_report(name, price, totalPurchases, totalSales, avgPrice, avgDiscount, avgDiscountPercentage)

  end
end

### end of products methods

### Brands methods

def get_unique_brands(products_hash)
  brands_hash = {}
  products_hash["items"].each do |toy|
    brands_hash[toy["brand"]] = 1
  end
  
  return brands_hash
end

def print_brands_report(brandsVariables, name)
  puts ""
  puts name
  print_hr
  puts "Number of Products: " + brandsVariables["brandsToysStock"].to_s
  puts "Average Product Price: $" + sprintf('%.2f', brandsVariables["brandsAvgProductPrice"])
  puts "Total Sales: $" + sprintf('%.2f', brandsVariables["brandsTotalSales"])
end

def calculate_brands_variables(products)
	brandsVariables = { "brandsToysStock" => 0, "brandsPriceSum" => 0, "brandsTotalSales" => 0}
	products.each do |product|
	  brandsVariables["brandsToysStock"] += product["stock"]
	  brandsVariables["brandsPriceSum"] += product["full-price"].to_f
	  
	  totalProductSales = product["purchases"].inject(0) {|sum, purchase| sum + purchase["price"]}
	  brandsVariables["brandsTotalSales"] += totalProductSales
	end
	brandsVariables["brandsAvgProductPrice"] = brandsVariables["brandsPriceSum"] / products.length
	
	return brandsVariables
end

def generate_brands_report(products_hash)

  brands_hash = get_unique_brands(products_hash)
  
  brands_hash.each do |name, brand|
	
	products = products_hash["items"].select{|toy| toy["brand"] == name}
	
	brandsVariables = calculate_brands_variables(products)
	
	print_brands_report(brandsVariables, name)
	
  end
end

### end of brands methods

### initialization method

def start(products_hash)
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

  generate_products_report(products_hash)	
	
  # Print "Brands" in ascii art

  print_ascii_art('Brands')

  # For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

  generate_brands_report(products_hash)
end

start(products_hash)

