require 'colorize'
require_relative 'contact'
CSV_FILE = 'contacts.csv'

class AlreadyExists < RuntimeError
end

help_message = "Here is a list of available commands:
    new - Create a new contact
    list - List all contacts 
    show - Show a contact
    find [id]- Find a contact
    update [id] - change an entry
    destroy [id] - delete an entry from database"

def create_contact_rescue
  begin
    create_contact
  rescue
    puts "Email already exits, cannot be entered".colorize(:red)
  end
end


ARGV << 'help' if ARGV.empty?
case ARGV[0].downcase
when "help"
  puts help_message
when "list"
  Contact.list
when "new"
  Contact.create_contact
when "show"
  Contact.show(ARGV[1])
when "find"
  Contact.find(ARGV[1])
when "search"
  Contact.search(ARGV[1])
when "update"
  contact = Contact.find(ARGV[1])
  contact.update
when "destroy"
  contact = Contact.find(ARGV[1])
  contact.destroy
end
