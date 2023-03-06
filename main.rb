# SOLID DESIGN PRINCIPLES

# Issue 5:
# Dependency inversion principle means:
# that our classes should depend on abstractions and not in concrete subclasses.

# In this code, this is already an isue, because the PaymentProcessor depending on the sms authorizer
# what about if we want to add another type of authorizers, like not a robot, we can't use the SMSAuthentication.

# Solution:
# Remove the concrete sms authorizer dependency and use a generic autorizer instead.

class PaymentProcessor
  def pay(order)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class Authorizer
  def authorized?
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

class SMSAuthentication < Authorizer
  def initialize
    @authorized = false
  end

  def verify_code(code)
    puts "Verifying SMS code #{code}\n"
    @authorized = true
  end

  def authorized?
    @authorized
  end
end

class NotARobot < Authorizer
  def initialize
    @authorized = false
  end

  def not_a_robot
    puts "Are you a robot? \n"
    @authorized = true
  end

  def authorized?
    @authorized
  end
end

class DebitPaymentProcessor < PaymentProcessor
  def initialize(security_code, authorizer)
    @security_code = security_code
    @authorizer = authorizer
  end

  def pay(order)
    raise Exception, "Not authorized" unless @authorizer.authorized?

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
  def initialize(email_address, authorizer)
    @email_address = email_address
    @authorizer = authorizer
  end

  def pay(order)
    raise Exception, "Not authorized" unless @authorizer.authorized?

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

authorizer = NotARobot.new
authorizer.not_a_robot

processor = PaypalPaymentProcessor.new('test@example.com', authorizer)
processor.pay(order)