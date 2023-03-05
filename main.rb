# SOLID DESIGN PRINCIPLES

# Issue 4:
# Let's include a two-factor authentication inside the PaymentProcessor class.

# The issue here is that defining a generic interface like the PaymentProcessor to do multiples things
# that are not applicable to subclasses.

# This violates the interfae segregation principle, because not all subclasses support two-factor authentication.

# Interface segregation principle says:
# It is better, if you have have several specific interfaces as opposed to one general purpose insterface.

# Solution:
# So it is better to create a separate interfaces for this case.
# For example, we could add a subclass of PymentProcessor that adds SMS two-factor authentication.

class PaymentProcessor
  def pay(order, security_code)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class PaymentProcessorWithSMS < PaymentProcessor
  def auth_sms(code)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class DebitPaymentProcessor < PaymentProcessorWithSMS
  def initialize(security_code)
    @security_code = security_code
    @verified = false
  end

  def pay(order)
    raise Exception, "Not authorized" unless @verified

    puts "Processing debit payment\n"
    puts "Verifying security code #{@security_code}\n"
    order.status = 'paid'
  end

  def auth_sms(code)
    puts "Verifying SMS code #{code}\n"
    @verified = true
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

class PaypalPaymentProcessor < PaymentProcessorWithSMS
  def initialize(email_address)
    @email_address = email_address
    @verified = false
  end

  def pay(order)
    raise Exception, "Not authorized" unless @verified

    puts "Processing paypal payment\n"
    puts "Verifying email address #{@email_address}\n"
    order.status = 'paid'
  end

  def auth_sms(code)
    puts "Verifying SMS code #{code}\n"
    @verified = true
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
processor.auth_sms('329850')
processor.pay(order)