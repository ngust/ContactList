require 'csv'
# Represents a person in an address book.
class Contact

  attr_accessor :name, :email, :index
  CSV_FILE = 'contacts.csv'

  def initialize(name, email, index=nil)
    @name = name
    @email = email
    @index = index
    csv_array = [@index, @name, @email]
    CSV.open(CSV_FILE, 'ab'){|csv_object| csv_object << csv_array}
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

    def list
      row_count = 0
        CSV.foreach(CSV_FILE) do |row|
          row_count +=1
          puts "#{row[0]}: #{row[1]} (#{row[2]})"
        end
      puts "---"
      puts "Total Records: #{row_count}"
    end

    def search(query)
      row_count = 0
      CSV.foreach(CSV_FILE) do |row|
        row.each do |word|
          if word.include?(query)
            puts "#{row[0]}: #{row[1]} (#{row[2]})"
            row_count +=1
          end
        end
      end
      puts "No users found." if row_count == 0
      puts "---"
      puts "Total Records: #{row_count}"
    end

  end #class self

end #class