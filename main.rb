# SOLID DESIGN PRINCIPLES

# liskov substitution
# if you have objects in a program you should be able to replace these objects with instances of their subclasses
# withour altering the correctss of the program.

# Issue 2:
# Paypal payment does not work with security code, but with email address instead.
# If we want to fix that without changing anything in the code, 
# we should make sure that the pay method receive an email address and not a security code.

# This violates the liskov substitution principle because the email address is not kind of security code.


# Solution:
# Remove the security_code dependency from the pay method and setting it in the initializer.

class PaymentProcessor
  def pay(order, security_code)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class DebitPaymentProcessor < PaymentProcessor
  def initialize(security_code)
    @security_code = security_code
  end

  def pay(order)
    puts "Processing debit payment\n"
    puts "Verifying security code #{@security_code}\n"
    order.status = 'paid'
  end
end

class CreditPaymentProcessor < PaymentProcessor
  def initialize(security_code)
    @security_code = security_code
  end

  def pay(order)
    puts "Processing credit payment\n"
    puts "Verifying security code #{@security_code}\n"
    order.status = 'paid'
  end
end

class PaypalPaymentProcessor < PaymentProcessor
  def initialize(email_address)
    @email_address = email_address
  end

  def pay(order)
    puts "Processing paypal payment\n"
    puts "Verifying email address #{@email_address}\n"
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

processor = PaypalPaymentProcessor.new('test@example.com')
processor.pay(order)