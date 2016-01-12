require_relative 'contact'
CSV_FILE = 'contacts.csv'

help_message = "Here is a list of available commands:
    new - Create a new contact
    list - List all contacts 
    show - Show a contact
    find - Find a contact
    add - Add phone number(s) to existing contact"

def create_contact
  puts "Enter your name:"
  name = STDIN.gets.chomp
  puts "Enter your email:"
  email = STDIN.gets.chomp
  @contact = Contact.new(name, email, @index)
end

def caclulate_index
  col_data = []
  CSV.foreach(CSV_FILE) {|row| col_data << row[0].to_i}
  @index = col_data.max
  @index += 1
end

ARGV << 'help' if ARGV.empty?
case ARGV[0].downcase
when "help"
  puts help_message
when "list"
  Contact.list
when "new"
  caclulate_index
  create_contact
  puts "#{@contact.inspect} was added to the list"
when "show"
  Contact.show(ARGV[1])
when "search"
  Contact.search(ARGV[1])
end
