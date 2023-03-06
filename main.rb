# SOLID DESIGN PRINCIPLES

# We want to write code that is open for extention and closed for modifications
# So we should be able to extend the exisitng code with new functionality but we should not modify th original code.

# Issue 2:
# If we want to add a new payment method, we should modify the PaymentProcessor class
# This violates the Open/Closed principle

# Solution:
# Create a structure of of classes and subsclasses
# So we can define a subclass for each new payment method

class PaymentProcessor
  def pay(order, security_code)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class DebitPaymentProcessor < PaymentProcessor
    def pay(order, security_code)
    puts "Processing debit payment\n"
    puts "Verifying security code #{security_code}\n"
    order.status = 'paid'
  end
end

class CreditPaymentProcessor < PaymentProcessor
  def pay(order, security_code)
    puts "Processing credit payment\n"
    puts "Verifying security code #{security_code}\n"
    order.status = 'paid'
  end
end

class PaypalPaymentProcessor < PaymentProcessor
  def pay(order, security_code)
    puts "Processing paypal payment\n"
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

processor = DebitPaymentProcessor.new
processor.pay(order, '549820')