require 'csv'
require 'pg'
# Represents a person in an address book.
class Contact

  DATABASE_NAME = 'contact_list'
  CONNECT = PG::Connection.open(dbname: DATABASE_NAME)

  attr_accessor :name, :email, :index, :phone_no
  CSV_FILE = 'contacts.csv'

  def initialize(name, email, index=nil, phone_no)
    @name = name
    @email = email
    @index = index
    @phone_no = phone_no
    csv_array = [@index, @name, @email, @phone_no]
  end

  def destroy
      pkey = self.index
      res = CONNECT.exec_params('DELETE FROM contact WHERE id = $1;',[pkey])
      puts "Index ##{pkey} was deleted"
  end

  def update
      pkey = self.index
      name = Contact.get_name
      email = Contact.get_email
      puts "No phone number updates allowed, sorry."
      #raise AlreadyExists, "Email already exits" if Contact.email_exists?(email)
      res = CONNECT.exec_params('UPDATE contact SET name = $1, email = $2, phone_number = $3 WHERE id = $4;', [name, email, @phone_hash, pkey])
  end

  # Provides functionality for managing a list of Contacts in a database.
  class << self

    def show(id)
      CSV.foreach(CSV_FILE) do |row|
        if row[0] == id
          puts "ID: #{row[0]}"
          puts "Name: #{row[1]}"
          puts "Email: #{row[2]}"
          return
        end
      end
      puts "No user with that ID."
    end

    def list   ##  Use .map instead on all
      table = CONNECT.exec('SELECT * FROM contact;')
        all = []
        table.each do |ent|
          contact = Contact.new(ent['name'], ent['email'], ent['id'], ent['phone_number'])
          all << contact
        end
        p all
    end

    def find(id)
      res = CONNECT.exec_params('SELECT * FROM contact WHERE id = $1::int', [id])
      #p res[0]
      contact = Contact.new(res[0]['name'], res[0]['email'], res[0]['id'], res[0]['phone_number'])
      puts "Index: #{contact.index}"
      puts "Name: #{contact.name}"
      puts "Email: #{contact.email}"
      puts "Phone No: #{contact.phone_no}"
      puts "---"
      contact
    end

    def search(query)
      res = CONNECT.exec_params('SELECT * FROM contact WHERE name LIKE $1 OR email LIKE $1;', ["%#{query}%"])
      contact = Contact.new(res[0]['name'], res[0]['email'], res[0]['id'], res[0]['phone_number'])
      puts "Index: #{contact.index}"
      puts "Name: #{contact.name}"
      puts "Email: #{contact.email}"
      puts "Phone No: #{contact.phone_no}"
      puts "---"
      contact
      ###  Fix so that multiple contact objects are returned.
    end


    def email_exists?(email)
      CSV.foreach(CSV_FILE) do |row|
        if row[2].downcase == email.downcase
          return true
        end
      end
    false
    end

    def create_contact
      puts "Enter your name:"
      name = STDIN.gets.chomp
      puts "Enter your email:"
      email = STDIN.gets.chomp
      #raise AlreadyExists, "Email already exits" if Contact.email_exists?(email)
      add_phone
      res = CONNECT.exec_params('INSERT INTO contact (name, email, phone_number) VALUES ($1, $2, $3) RETURNING id', [name, email, @phone_hash])
      #self.id = res[0]['id']
      ###  Print out person who was added
    end

    def add_phone ## Not Working ---> FIX
      @phone_hash = {}
      more_numbers = true
      while more_numbers
        print "What kind of phone? (home, cell, work): "
        phone_key = STDIN.gets.chomp
        print "Enter phone number (123-123-123): "
        phone_number = STDIN.gets.chomp
        @phone_hash[phone_key] = phone_number
        print "Want to add anouther phone? (y/n)"
        more_phones = STDIN.gets.chomp.downcase
          if more_phones == "n"
            more_numbers = false
          end
      end
    end


    def get_name
      puts "Enter updated name:"
      STDIN.gets.chomp
    end

    def get_email
        puts "Enter updated email:"
        STDIN.gets.chomp
    end
  end #class self

end #class