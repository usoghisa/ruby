#############################
# VIP This file require collection.txt in the same folder 
#############################
require 'set'
#______________________________________________________________________________________
# Calendar class deal the passage of time
# instance var :date using time class
# fuction advance() Increment the date next day
class Calendar
  # attr_accessor:date
  attr_reader(:date)
  def initialize()
    @date = Time
  end

  def get_date()
    t = Time.now
    d= t.strftime("%Y%m%d")
    return  t
  end

  def advance()
    @date = get_date + (24*60*60)
    return   @date
  end
end
#______________________________________________________________________________________
# Book class has following instace variable :id, :title, :author :dueDate borrowPeriod
class Book
  attr_reader(:id, :title, :author, :dueDate )
  def initialize(id,title,author)
    @dueDate = nil
    @borrowPeriod = 6
    @id = id
    @title = title
    @author = author
  end
  def getId()
    return @id
  end
  def get_due_date()
    return @dueDate
  end
  def check_in()
    @dueDate = nil
  end
  def to_s #"id:title,by author”.
    return "id: #{@id}, title #{@title}, by Author #{@author}"
  end
  def check_out(due_date)
    @dueDate = due_date
    # @dueDate =  Calendar.new().get_date()+ @borrowPeriod
  end
end
#______________________________________________________________________________________
# Member class has following instace variable :name, :bookBorrowed, :library
# methods send_overdue_notice(notice) Tells this member that has overdue books.
class Member
  attr_reader(:name, :bookBorrowed )
  def initialize(name,libraryName)
    @name = name
    @library = libraryName
    @bookBorrowed = []
  end

  def check_out(book)
    @bookBorrowed.push(book)
  end

  def give_back(book)
    @bookBorrowed.delete_at(@bookBorrowed.index(book))
  end

  def get_books()
    return @bookBorrowed
  end

  def send_overdue_notice(notice)
    puts self.name()+ notice
  end

end
#______________________________________________________________________________________
# Library class a number of methods which are called by the "librarian" (the user), not by members
# class var   @@books, @@isCalOn, @@isCollectionReaded @@members @@isLibOpen @@currentMembe
# methods find_all_overdue_books() , issue_card(name_of_member), serve(name_of_member) 
# check_in(*book_numbers),search(string),renew(*book_ids), close(),quit()
class Library
  attr_reader(:calendar )
  @@books = []
  @@isCalOn = false
  @@isCollectionReaded = false
  @calendar = nil
  def initialize()
    @calendar = Calendar.new()
    createCalendar()
    readFile()
    @@members = Hash.new
    @@isLibOpen=false
    @@currentMember=nil ###
  end
  def getBookList()
    return @@books
  end
  def getIsLibOpen()
     return @@isLibOpen
  end
  def getCurrentMember()
    return @@currentMember
  end  
  def getMember()
    return @@members
  end 
  def addMember(name, obj)
    @@members[name] = obj
  end
  def libIsOpen()
    (@@isLibOpen == false) ? (raise Exception.new("The library is not open")) : return  
  end
  def custIsServe()
    (@@currentMember == nil) ? (raise Exception.new("No member is currently been served")) : return 
  end
# current member book out and over   
def find_overdue_books() 
  libIsOpen()
  custIsServe()
  #puts"@@ currentMember.name book #{@@currentMember.bookBorrowed()[0].title}"
  bookOut=[[],[]]
  bookOut = loopBookArray(@@currentMember)
        if bookOut[1].size > 0
          @@currentMember.name
          print "#{@@currentMember.name} has overdue \n"
            bookOut[1].each do |i|  
              puts "#{i}  " 
            end
            return
        else 
          print "#{@@currentMember.name} has no overdue \n"
          return
        end       
end
def check_in(book_numbers)
  puts "Currrent Customer has "+ (book_numbers.to_s) +" book out"  
  libIsOpen() 
  libIsOpen() 
  custIsServe()
  findBook = false
  if (@@currentMember.bookBorrowed().size == 0) 
    raise Exception.new(" The member does have book id #{book_numbers}")
    return 
  end
  for i in (0..(@@currentMember.bookBorrowed().size)-1)
   
    if  (@@currentMember.bookBorrowed()[i].id() == book_numbers )
        findBook = true
        #@@currentMember.bookBorrowed()[i] = nil
        #@@currentMember.bookBorrowed().delete(nil)
        @@currentMember.bookBorrowed().delete_at(i)
        return "@@currentMember.name #{@@currentMember.name} has return book id #{book_numbers} bookBorrowed()ARRAY #{@@currentMember.bookBorrowed()}"
    end 
  end
  
  if(findBook == false)
      raise Exception.new(" The member does have book id #{book_numbers}")
  end  
end
=begin
  Checks out the book to the member currently being served (there must be one!), or tells why the operation is not permitted. 
  The book_ids could have been found by a recent call to the search method. Checking out a book will involve both telling the book that
  it is checked out and removing the book from this library's collection of available books.
  If successful, returns "n books have been checked out to name_of_member.". 
  EXCEPTION not open No cust serv  "The library does not have bookid."
=end
def check_out(book_ids) #1..n book_ids @@currentMember.name
  libIsOpen() 
  custIsServe()
  if (@@currentMember.get_books().size > 2) 
    return "Sorry #{@@currentMember.name} you check out 3 books already"
  end
  findBook = false
  #dueTime = (Time.now + (7*24*60*60)).strftime("%Y%m%d") # add 7 day
  dueTime = (Time.now + (7*24*60*60)) 
  for iB in 0 ... @@books.size
   # print "#{@@books[iB].id()} "+"#{@@books[iB].title()} "+"#{@@books[iB].author()} \n" 
    if (@@books[iB].id() == book_ids)
      findBook = true
      puts  @@books[iB].title()
      @@books[iB].check_out(dueTime)
      # @@books[iB].get_due_date()
      @@currentMember.check_out(@@books[iB])
      # @@currentMember.get_books()
      removeIndex = iB 
    end 
  end
  #puts @@books 
  if findBook == false
    findBook =  "The library does not have book  id #{book_ids}"
    return findBook
  else
   @@books.delete_at(removeIndex)
   return "The book with id #{book_ids} have been checked out to #{@@currentMember.name}." 
  end  
end

def renew(book_ids) #1..n book_ids
  for iB in 0 ... @@books.size 
  puts @@books[iB].get_due_date()
end

  libIsOpen() 
  custIsServe()
  findBook = false  
  for iB in 0 ... @@currentMember.get_books().size
     # print "#{@@books[iB].id()} "+"#{@@books[iB].title()} "+"#{@@books[iB].author()} \n" 
      if (@@currentMember.get_books()[iB].id() == book_ids)
        puts @@currentMember.get_books()[iB].get_due_date()
        findBook = true
        #dueTime = @@currentMember.get_books()[iB].get_due_date()
        #dueTime = dueTime + (7*24*60*60) # add 7 day
        t= @@currentMember.get_books()[iB].get_due_date()+(7*24*60*60)# add 7 day
                @@currentMember.get_books()[iB].check_out(t) 
        return  @@currentMember.get_books()[iB].get_due_date()
      end 
   end  
   if (findBook == false)
     raise Exception.new("The member does not have book id #{book_ids}")
   end    
end


## Finds those Books whose title or author (or both) contains this string. case insensitive *KKK and kkk*
=begin
  Finds those Books whose title or author (or both) contains this string.
  For example, the string "tact" might return, among other things,
  the book Contact, by Carl Sagan. The search should be case insensitive;
  that is, "saga" would also return this book.
=end

def search(string)
  string = string.squeeze(' ').strip
  libIsOpen() 
  result= nil 

     if (string.size > 3)
       s= string.split(' ').map(&:strip)
     else
       result = "Search string must contain at least four characters."
       return result
     end
      
  foundBook = Set.new []  
    
  ## search for title author  aux func
  def searchBooks(n,s,foundBook,iB)
    for i in 0 ... n.size
       for j in 0 ... s.size
         print "Loop author #{n[i].downcase.include?(s[j].strip.downcase)}\n"
         if (n[i].downcase.include?(s[j].strip.downcase))
           foundBook.add(@@books[iB])
         end 
       end    
     end
  end  
   
for iB in 0 ... @@books.size
  print "#{@@books[iB].id()} "+"#{@@books[iB].title()} "+"#{@@books[iB].author()} \n" 
  authorName = @@books[iB].author().split(' ').map(&:strip)
    searchBooks(authorName,s,foundBook,iB)
  titleName = @@books[iB].title.split(' ').map(&:strip)
    searchBooks(titleName,s,foundBook,iB)    
end
  
puts"__________"
if (foundBook.size == 0)
  return "No books found."
else
   foundBook.each{|i| puts i} 
    
end  
puts"__________"
return    

end  
  def serve(name_of_member) 
    libIsOpen()
    puts "@@currentMember #{@@currentMember}"
    if (@@currentMember != nil)  
      puts "sorry #{@@currentMember.name} but now i serve #{name_of_member}"
      @@currentMember = nil
    end  
    if (@@currentMember == nil)# puts getMember()
      if(isMember(name_of_member) == true)
        @@currentMember = getMember()[name_of_member.to_sym]
        #puts "@@currentMember.name is #{@@currentMember.name}"  
        return "Now serving #{@@currentMember.name} "
      else
        return "Sorry #{name_of_member} you must be a member to be served "
      end
    end
  end
  
  def isMember(name_of_member) #u= "k" puts "FFF2____ #{u == :k.to_s}"    puts  name_of_member
    found = false
    getMember().each_pair do |key,obj|
      if (key == name_of_member.to_sym)
        found = true
      end
    end
    return found
  end 
        
  def issue_card(name_of_member)
    libIsOpen()
    if (isMember(name_of_member) == false)
      addMember(name_of_member.to_sym, Member.new(name_of_member,"bbkLib"))
      return "\n Welcome #{name_of_member} to bbk"
    else
      return "Sorry this #{name_of_member} already exist"
    end
  end
    
  def open()
    if @@isLibOpen==true
      raise Exception.new("The library is already open")
    else
      @@isLibOpen=true
      @calendar.advance()
      return "Today is day +1  #{@calendar.date()}"
    end
  end
def close()
  if (@@isLibOpen == true)
      @@isLibOpen = false
      @@currentMember = nil
    return "Good night"
  else
    raise Exception.new("The library is not open.")
  end
end

def quit()
  #puts find_overdue_books() 
  return "The library is now closed for renovations"  
end
def loopBookArray(member)
      # [0] noOverDue [1] Over
      bookOut=[[],[]]   
      for i in 0 ... member.get_books.size
        if  ((member.get_books.size > 0)&&
        (member.get_books[i].get_due_date() <= @calendar.get_date() ))
          # bookOut[1].push(member.get_books[i].title())
          bookOut[1].push(member.get_books[i])
        end
      end
      return bookOut
end
  
=begin
  listing the names of members who have overdue books, and for each such member, the
  books that are overdue. Or, the string "No books are overdue.”.
=end
  def find_all_overdue_books()
    libIsOpen() 
    puts "__3"#puts @@books[1]
    bookOut=[[],[]]
    name=""
    getMember().each_pair do |key,obj|
      if obj.get_books.size == 0
        puts key
        puts " No book are overdue "
      end
      ##....loopBookArray(member)
      bookOut = loopBookArray(obj)
      if bookOut[1].size > 0
        name= key
        print "#{name} has overdue \n"
        bookOut[1].each do |i|
          puts "#{i} , "
        end 
      end     
    end
  end
  
  def readFile()
    # Read File with Exception Handling
    if @@isCollectionReaded==false
      counter = 1
      begin
        file = File.new("collection.txt", "r")
        while (line = file.gets)
          # puts "#{counter}: #{line}"
          title,author = line.split(',').map(&:strip)
          makeBookList(counter-1,counter,title,author)
          counter = counter + 1
        end
        file.close
        @@isCollectionReaded=true
      rescue => err
        puts "Exception: #{err}"
        err
      end
    end
  end
  def makeBookList(i,id,title,author)
    @@books[i] = Book.new(id,title,author)
  end


  def createCalendar()
    if @@isCalOn == false
      @calendar = Calendar.new()
      puts @calendar.get_date()
      @@isCalOn = true
      #puts @@isCalOn
    end
  end
end



###########################################
## START INTERACT WHIT THE APP
###########################################

begin
### Open Library add member
puts "### Open Library add member____________________________________________________"
l=Library.new();
puts "The Library Is open #{l.open()}"
puts "CALL l.getBookList() #{l.getBookList()}"
puts "CALL l.addMember ugo #{l.addMember(:ugo, Member.new("ugo","bbkLib"))}"
puts "CALL l.addMember pep #{l.addMember(:pep, Member.new("pep","bbkLib"))}"
puts "CALL l.addMember nino #{l.addMember(:nino, Member.new("nino","bbkLib"))}"
puts "CALL l.calendar() #{l.calendar().get_date()}"

### Borrow Book
puts "### Get Borrow Book and over due _______________________________________________"
t=(l.calendar().get_date())+(7*24*60*60)
puts "CALL l.getMember()[:ugo].check_out(l.getBookList()[0]) #{l.getMember()[:ugo].check_out(l.getBookList()[0])}"
puts "CALL l.getBookList()[0].check_out(t) #{l.getBookList()[0].check_out(t)}"
puts "CALL l.getMember()[:ugo].inspect #{l.getMember()[:ugo].inspect}"
puts "CALL l.getMember()[:ugo].bookBorrowed[0].getId() #{l.getMember()[:ugo].bookBorrowed[0].getId()}"
puts "CALL l.getMember()[:ugo].bookBorrowed[0].get_due_date #{l.getMember()[:ugo].bookBorrowed[0].get_due_date}"
puts "CALL l.find_all_overdue_books() #{l.find_all_overdue_books()}"
puts "CALL l.getMember()  #{ l.getMember() }"

### Issue card and serve customer
puts "### Issue card and serve _______________________________________________________"
puts "CALL issue_card gino #{l.issue_card('gino')}"
puts "CALL issue_card gino again #{l.issue_card('gino')}"
puts "CALL serve('gino') #{l.serve('gino')}"
puts "CALL serve('ugo') #{l.serve('ugo')}"
#puts "CALL serve('kkk') #{l.serve('kkk')}"#################################### to check

### Check_in and search
puts "### Check_in and search _______________________________________________"  
puts "l.check_in(1)  #{l.check_in(1)} " 
#puts "l.check_in(2)  #{l.check_in(2)} "

puts "+++ l.search('   saga ArL tact  ttt1 ')  #{l.search("   saga ArL tact  ttt1 ")} " 
#puts l.search("   saga ArL tact  ttt1 ") #################################### try
#puts l.search("   TTTT  autho ")
####################################################################TO DO
puts "CALL check_out(book_ids 1) #{l.check_out(1)} "   
puts "CALL check_out(book_ids 2) #{l.check_out(2)} "
puts "CALL check_out(book_ids 3) #{l.check_out(3)} "      
puts "CALL check_out(book_ids 4) #{l.check_out(4)} " 

puts "CALL renew(book_ids 1) #{l.renew(1)} " 
#puts "CALL renew(book_ids 22) #{l.renew(22)} "

puts "CALL close() 1 #{l.close()} "
#puts "CALL close() 2 #{l.close()} "
puts "CALL quit() #{l.quit()} " 

puts "The Library Is open #{l.open()}"
puts "The custIsServe() #{l.custIsServe()}"
rescue Exception => e
  puts e.message
end


puts "call serve('ugo')   #{l.serve('ugo')}"
puts "l.getCurrentMember.name)   #{l.getCurrentMember.name }"
#puts "l.getCurrentMember.name)   #{l.getCurrentMember.bookBorrowed}"
#puts "find_overdue_books()  #{l.find_overdue_books()}"
#puts "find_overdue_books()  #{l.find_overdue_books()}"
puts "l.getCurrentMember.bookBorrowed)   "
n=[]


puts "call serve('pep') #{l.serve('pep')}" 

sz = (l.getCurrentMember.bookBorrowed.size)
for i in 0..(sz-1) do
   n.push(l.getCurrentMember.bookBorrowed[i].getId())
   puts n[i]   
end
if(n.size > 0)
  if(n[0] != nil)
    puts l.check_in(n[0])
  end
  if(n[1] != nil)
    puts l.check_in(n[1])
  end 
  if(n[2] != nil)
    puts l.check_in(n[2])
  end   
end

puts "l.getCurrentMember.bookBorrowed)   "
puts l.getCurrentMember.bookBorrowed.size   




######################################################################## end

=begin 
begin
l=Library.new();
puts " The Library Is open #{l.open()}"
#l.open()

puts "ooo"
puts "getBookList() #{l.getBookList()}"
#l.getBookList()[1].check_out(20141215)
# add member to lib
l.addMember(:ugo, Member.new("ugo","bbkLib"))
l.addMember(:pep, Member.new("pep","bbkLib"))
#l.addMember(:nino, Member.new("nino","bbkLib"))  



### Borrow Book
l.getMember()[:ugo].check_out(l.getBookList()[0])
l.getMember()[:ugo].check_out(l.getBookList()[1])
#l.getBookList()[0].check_out(20141215) 
#l.getBookList()[1].check_out(20141215) 
 
# puts l.getMember()[:ugo].inspect
puts l.getMember()[:ugo].bookBorrowed[0].getId()
puts l.getMember()[:ugo].bookBorrowed[0].get_due_date
puts l.getMember()[:ugo].bookBorrowed[1].getId()


l.find_all_overdue_books()
# puts l.getMember() 

  puts "call issue_card gino   #{l.issue_card('gino')}"
  puts "call issue_card 2   #{l.issue_card('gino')}"
  puts "call serve('gino')   #{l.serve('gino')}"
  puts "call find_overdue_books()"
  puts "#{l.find_overdue_books()}"
  
  puts "call serve('ugo')   #{l.serve('ugo')}"
  #puts "serve('kkk')   #{l.serve('kkk')}" 
  puts "call find_overdue_books()"
  puts "#{l.find_overdue_books()}"
  puts "l.check_in(1)  #{l.check_in(1)} "  
  puts "l.check_in(22)  #{l.check_in(2)} "   
  #puts l.search("   saga ArL tact  ttt1 ")
  puts l.search("   TTTT  autho ")
  #foundBook.each{|i| puts i} 
#puts "CALL check_out(book_ids 33) #{l.check_out(33)} "    
puts "CALL check_out(book_ids 1) #{l.check_out(1)} "   
#puts "CALL check_out(book_ids 2) #{l.check_out(2)} "
#puts "CALL check_out(book_ids 3) #{l.check_out(3)} "      
#puts "CALL check_out(book_ids 4) #{l.check_out(4)} " 
puts "CALL renew(book_ids 1) #{l.renew(1)} " 
#puts "CALL renew(book_ids 22) #{l.renew(22)} "
#puts "CALL close() 1 #{l.close()} "
#puts "CALL close() 2 #{l.close()} "
#puts "CALL quit() #{l.quit()} "
rescue Exception => e
  puts e.message
end



=begin
  b= Book.new(111,"ttt","aaa")
  b2= Book.new(222,"ttt","bbb")
  b.check_out(20141215)
  #puts b.title()
  #puts b.inspect
  #puts b.to_s

  m = Member.new("ug","lug")
  m.check_out(b)
  m.check_out(b2)
  #m.give_back(b2)
  puts m.get_books()
  m.send_overdue_notice(" book is overdue")
=end

###############################
