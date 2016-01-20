require_relative 'contact'
#require_relative 'contact_database'

case ARGV[0]
when "help"
  puts "Here is a list of available commands:
    new - Create a new contact
    list - List all contacts 
    show - Show a contact
    find - Find a contact
    add - Add phone number(s) to existing contact"
when "new"
  ARGV.shift
  print "Email: "
  email = gets.chomp
  if Contact.email_already_in_db?(email)
    puts "Cannot add contact, email is already in the database."
    exit
  end
  print "Full name: "
  full_name = gets.chomp
  phone_hash = {}
  add_number = true
  while add_number
  print "Enter phone type (ie. 'home', 'mobile', 'work'): "
  phone_hash_key = gets.chomp
  print "Enter phone number (ie. 123-123-123): "
  phone_hash_value = gets.chomp
  phone_hash[phone_hash_key] = phone_hash_value
  print "Add another number? (y/n): "
  another_number_input = gets.chomp
    if another_number_input == "n"
      add_number = false
    end
  end

  contact = Contact.new(full_name, email, phone_hash)
when "list"
  Contact.list
when "add"
    
end

case 
when ARGV[0] == "show" && !ARGV[1].nil?
  Contact.show(ARGV[1])
when ARGV[0] == "find" && !ARGV[1].nil?
  Contact.find(ARGV[1])
end



