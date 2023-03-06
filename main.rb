# SOLID DESIGN PRINCIPLES

# We want classes and methods to have single responsabilties
# High cohesion => to be responsible for only a single thing that ensures that you can reuse them later on

# In this example, this Order class does many things:
## Adds item to the order
## Calculate total price
## Pay the order?

# Issue 1:
# Handeling the payment should not be part of the order

# Solution:
# Extract the payment method to a separate class
# Later we might add other payment types: Bitcoin, Apple pay...
# We can add it the payment class instead of the Order class.
# Both classes have single responsabilites

class PaymentProcessor
  def pay_debit(order, security_code)
    puts "Processing debit payment\n"
    puts "Verifying security code #{security_code}\n"
    order.status = 'paid'
  end

  def pay_credit(order, security_code)
    puts "Processing credit payment\n"
    puts "Verifying security code #{security_code}\n"
    order.status = 'paid'
  end
end

class Order
  attr_writer :status

  def initialize
    @items = []
    @quantities = []
    @prices = []
    @status = 'open'
  end

  def add_item(name, quantity, price)
    @items << name
    @quantities << quantity
    @prices << price
  end

  def total_price
    @prices.each_with_index { |price, index| price * @quantities[index] }.sum
  end
end

order = Order.new
order.add_item('Laptop', 1, 1700)
order.add_item('Mouse', 1, 20)
order.add_item('Keyboard', 1, 50)

puts "#{order.total_price}\n"

processor = PaymentProcessor.new
processor.pay_debit(order, '549820')