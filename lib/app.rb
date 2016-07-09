require 'json'
require 'artii'

path = File.join(File.dirname(__FILE__), '../data/products.json')
file = File.read(path)
products_hash = JSON.parse(file)

def print_ascii_art(text)
  a = Artii::Base.new
  puts a.asciify(text)
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

# Print "Brands" in ascii art

print_ascii_art('Brands')

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined
