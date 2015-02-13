# encoding: UTF-8
module FormatHelper
  def money_format(number)
    if number.nil?
      return ""
    elsif number == ""
      return ""
    else
      number = number_with_precision(number, :precision => 2, :delimiter => ',')
      "£#{number}"
    end
  end

  def money_format_no_currency(number)
    number_with_precision(number, :precision => 2, :delimiter => ',')
  end

  def datetime_format(date_string)
    return Date.today.strftime('%d/%m/%Y %T') if date_string.nil?  #Null case
    return Time.at(date_string).strftime('%d/%m/%Y %T')  if date_string.is_a? (Bignum) or date_string.is_a? (Fixnum) #Convert from Epoch time
    return date_string.strftime("%d/%m/%Y %T")	#Convert from regular string
  end

  def date_format(date_string)
    return "" if date_string.nil?
    return Time.at(date_string).strftime('%d/%m/%Y')  if date_string.is_a? (Bignum) or date_string.is_a? (Fixnum)
    return date_string.strftime("%d/%m/%Y")
  end

  def date_format_mysql(date_string)
    return "" if date_string.nil?
    return Time.at(date_string.to_i).strftime('%Y-%m-%d %T') 

  end



  def time_format(date_string)
    return Date.today.strftime('%T') if date_string.nil?  #Null case
    return Time.at(date_string).strftime('%T')  if date_string.is_a? (Bignum) or date_string.is_a? (Fixnum) #Convert from Epoch time
    return date_string.strftime("%T")  #Convert from regular string
  end

    def time_format_short(date_string)
    return Date.today.strftime('%H:%M') if date_string.nil?  #Null case
    return Time.at(date_string).strftime('%H:%M')  if date_string.is_a? (Bignum) or date_string.is_a? (Fixnum) #Convert from Epoch time
    return date_string.strftime("%H:%M")  #Convert from regular string
  end

  def escape_nil(data) #added as a catch all formatter for dealing with strings from the database that could be nill. Will prevent errors in display and concatenation etc.
    if data==nil then return "" else return data end
  end

end