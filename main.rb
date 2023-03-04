# SOLID DESIGN PRINCIPLES

# We want to write code that is open for extention and closed for modifications
# So we should be able to extend the exisitng code with new functionality but we should not modify th original code.

# Issue 2:
# If we want to add a new payment method, we should modify the PaymentProcesor class
# This violates the Open/Closed principle

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