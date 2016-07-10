require 'json'
require 'artii'

### common methods

### I'm totally not sure about it - I tried to somehow make use of this global variable
### safer by just returning it to local variable. Normally I would use maybe Singleton with some consts
### but I was not sure if I can define class in this assignment. Well, it works...
def get_products_hash
  !$path ||= File.join(File.dirname(__FILE__), '../data/products.json')
  !$file ||= File.read($path)
  !$global_products_hash ||= JSON.parse($file)
  return $global_products_hash
end

### now I'll try just global variable approach
def set_global_report_file
  $report = File.new("../report.txt", "w")
end

def print_ascii_art(text)
  a = Artii::Base.new
  $report.puts a.asciify(text)
end

# print horizontal line
def print_hr(length = 20)
  $report.puts "*" * length
end

### end of common methods

### Products methods

def print_products_report(name, price, totalPurchases, totalSales, avgPrice, avgDiscount, avgDiscountPercentage)
  $report.puts
  $report.puts name
  print_hr
  $report.puts "Price: $" + price.to_s
  $report.puts "Total purchases: " + totalPurchases.to_s
  $report.puts "Total sales: $" + totalSales.to_s
  $report.puts "Average price: $" + avgPrice.to_s
  $report.puts "Average discount: $" + sprintf('%.2f', avgDiscount)
  $report.puts "Average discount (percentage): " + sprintf('%.2f%', avgDiscountPercentage)
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
  products_hash["items"].collect {|toy| toy["brand"]}.uniq
end

def print_brands_report(brandsVariables, name)
  $report.puts ""
  $report.puts name
  print_hr
  $report.puts "Number of Products: " + brandsVariables["brandsToysStock"].to_s
  $report.puts "Average Product Price: $" + sprintf('%.2f', brandsVariables["brandsAvgProductPrice"])
  $report.puts "Total Sales: $" + sprintf('%.2f', brandsVariables["brandsTotalSales"])
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

def create_report(products_hash)
  # Print "Sales Report" in ascii art
 
  print_ascii_art('Sales Report')

  # Print today's date

  time = Time.new
  $report.puts print_ascii_art(time.strftime("%d / %m / %Y"))

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

### initialization method

def start(products_hash = get_products_hash)

  ### not sure if this line should go in create_report method, its just
  ### that I think this start method is pretty useless (but I had to have it as requirement)
  ### Am I missing something here?
  set_global_report_file
  
  create_report(products_hash)
 
end

### main body of app :P

start

