#############################
# VIP This file require collection.txt in the same folder as Library.rb 
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
  #attr_reader(:calendar )
  @@books = Array[]
  @@isCalOn = false
  @@isCollectionReaded = false
  @@calendar = nil
  @@currentMember=nil 
  def initialize()
    #@@calendar = Calendar.new()
    createCalendar()
    readFile()
    @@members = Hash.new
    @@isLibOpen=false

  end
  def getCalendar()
    return @@calendar
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
  def getIsCollectionReaded()
     return @@isCollectionReaded
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
#_________________________________________________________  
# current member book out and over due   
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
# helper to find_overdue_books()
def loopBookArray(member)
      # [0] noOverDue [1] Overdue
      bookOut=[[],[]]  
      for i in 0 ... (member.get_books.size)
        if  ((member.get_books.size > 0)&&
        (member.get_books[i].dueDate <= @@calendar.get_date() ))
        bookOut[1].push(member.get_books[i])
        end
      end
      return bookOut
end
#___________________________________________________________
# return book to library print msg with name, book_numbers is book id 
def check_in(book_numbers)
  libIsOpen() 
  custIsServe() 
  findBook = false
  if (@@currentMember.bookBorrowed().size == 0) 
    raise Exception.new("The current member does't have book id #{book_numbers}")
    return 
  end  
  bor = @@currentMember.bookBorrowed()
  bor.map{|e| 
    if (e.getId() == book_numbers)
      findBook == true
      @@currentMember.bookBorrowed().delete(e)
      @@books[@@books.size] = e
        return "#{@@currentMember.name} has return book id #{book_numbers} "  
    end 
  } 
  if(findBook == false)
     raise Exception.new("The current member does't have book id #{book_numbers}")
  end  
end
#_____________________________________________________________________ 
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
  findBook = false #dueTime = (Time.now + (7*24*60*60)).strftime("%Y%m%d") # add 7 day
  dueTime = (Time.now + (7*24*60*60)) ##################### CHANGE + to - to check overdue
  for iB in 0 ... (@@books.size)
    if (@@books[iB].id() == book_ids)
      findBook = true # puts  @@books[iB].title()########## print title
      @@books[iB].check_out(dueTime) #set book due  @@books[iB].get_due_date()
      @@currentMember.check_out(@@books[iB]) # chech out book to cust # @@currentMember.get_books()
      removeIndex = iB 
    end 
  end
    if (findBook == false)
      raise Exception.new("The library does not have book id #{book_ids}")
    else
      @@books.delete_at(removeIndex)
      return "The book with id #{book_ids} have been checked out to #{@@currentMember.name}." 
    end  
end
#______________________________________________________________
### just for testing overdue 
def make_overDue(book_ids) 
  b = @@currentMember.get_books()
  dueTime = (Time.now - (7*24*60*60)) ##################### CHANGE + to - to check overdue
    print b.size
  for iB in (0..(b.size-1))
    if (b[iB].id() == book_ids)
        b[iB].check_out(dueTime) #set book due  @@books[iB].get_due_date()
    end 
  end
end
#______________________________________________________________
### renew date of due, lib must be open, customer must be serve, trow exception if no book is founded
def renew(book_ids) #1..n book_ids
  libIsOpen() 
  custIsServe()
  findBook = false  
  for iB in 0 ... @@currentMember.get_books().size
     # print "#{@@books[iB].id()} "+"#{@@books[iB].title()} "+"#{@@books[iB].author()} \n" 
      if (@@currentMember.get_books()[iB].id() == book_ids)
        #puts "BOKK ID #{book_ids} is due  #{@@currentMember.get_books()[iB].get_due_date()}"
        findBook = true #dueTime = @@currentMember.get_books()[iB].get_due_date()
        #dueTime = dueTime + (7*24*60*60) # add 7 day
        t= @@currentMember.get_books()[iB].get_due_date()+(7*24*60*60)# add 7 day
        @@currentMember.get_books()[iB].check_out(t) 
        return ("date is renew and now the book will be available from #{ @@currentMember.get_books()[iB].get_due_date()}")
      end 
   end 
   if (findBook == false)
     raise Exception.new("The member does not have book id #{book_ids}")
   end    
end

#_______________________________________________________________________
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
         #print " Loop author #{n[i].downcase.include?(s[j].strip.downcase)}"############## VIP print search output########################
         if (n[i].downcase.include?(s[j].strip.downcase))
           foundBook.add(@@books[iB])
         end 
       end    
     end
  end    
for iB in 0 ... @@books.size
  #print "\n #{@@books[iB].id()} "+"#{@@books[iB].title()} "+"#{@@books[iB].author()}" 
  authorName = @@books[iB].author().split(' ').map(&:strip)
    searchBooks(authorName,s,foundBook,iB)
  titleName = @@books[iB].title.split(' ').map(&:strip)
    searchBooks(titleName,s,foundBook,iB)    
end #puts"\n___FOUND BOOK____"
  if (foundBook.size == 0)
    return "No books found."
  else #foundBook.each{|i| puts i} 
    foundBook.each{|i| result = result.to_s + (i.to_s)}          
  end    
  return result  
end 
#___________________________________________________________ 
# Returns either "Now serving name_of_member." or "name_of_member does not have a library card."
  def serve(name_of_member) 
    libIsOpen()
    if (!isMember(name_of_member)) 
      #puts "@@currentMember #{@@currentMember}" 
        return  name_of_member +" does not have a library card." 
    else  puts name_of_member + " you are member " 
    end
    if (@@currentMember != nil)  
      puts "Sorry #{@@currentMember.name} but now I serve #{name_of_member}"
      @@currentMember = nil
    end 
    if (@@currentMember == nil)# puts getMember()
      if(isMember(name_of_member) == true)
        @@currentMember = getMember()[name_of_member.to_sym]
        #puts "@@currentMember.name is #{@@currentMember.name}"  
        return "Now serving #{@@currentMember.name} "
      else
        puts "Sorry #{name_of_member} you must be a member to be served "
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
      return "Welcome #{name_of_member} to BBK library"
    else
      return "Sorry this #{name_of_member} already exist"
    end
  end
    
  def open()
    if @@isLibOpen==true
      raise Exception.new("The library is already open")
    else
      @@isLibOpen=true
      #@@calendar.advance()
      return "Today is day  #{@@calendar.get_date()}"
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
    #puts "overdue books #{find_overdue_books()}"
    return "The library is now closed for renovations"  
  end

#_______________________________________________________________________  
# listing the names of members who have overdue books, and for each such member, the
# books that are overdue. Or, the string "No books are overdue.”.
  def find_all_overdue_books()
    libIsOpen() #puts @@books[1]
    bookOut=[[],[]]
    overDueCust=""
    noOverDueCust=""
    result = ""
    getMember().each_pair do |key,obj|
      if obj.get_books.size == 0
        noOverDueCust = noOverDueCust.to_s + key.to_s + " has No book overdue \n"
      end
      # loopBookArray(member), i is book detail 
      bookOut = loopBookArray(obj)
      if bookOut[1].size > 0
        bookOut[1].each do |i|
          overDueCust = overDueCust.to_s + key.to_s + " has overdue book " + i.to_s + "\n"
        end   
      end     
    end
    return print("#{overDueCust}" + "#{noOverDueCust}")
  end


# ___________________________________  
# Read File with Exception Handling  
  def readFile()
    #if @@isCollectionReaded==false########
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
    #end#######
  end
  def makeBookList(i,id,title,author)
    @@books[i] = Book.new(id,title,author)
  end

  def createCalendar()
    if @@isCalOn == false
      @@calendar = Calendar.new()
      #puts @@calendar.get_date()
      @@isCalOn = true
      #puts @@isCalOn
    end
  end
end



###########################################
## START INTERACT With THE APPLICATION
###########################################

begin
  ### Open Library add member 
  puts "_____________________### Open Library add member__________________________________"
  l=Library.new();
  puts "The Library Is open #{l.open()}"
  puts "CALL l.getBookList() #{l.getBookList()}"
  puts "CALL l.addMember ugo #{l.addMember(:ugo, Member.new("ugo","bbkLib"))}"
  puts "CALL l.addMember pep #{l.addMember(:pep, Member.new("pep","bbkLib"))}"
  puts "CALL l.addMember nino #{l.addMember(:nino, Member.new("nino","bbkLib"))}"
  puts "CALL l.getCalendar #{l.getCalendar.get_date()}"
rescue Exception => e; puts e.message ; end
  
begin  
  ### Borrow Book set overdue show all overdue e no overdue 
  puts "### Borrow Book set overdue, show all overdue e no overdue _______________________________________________"
  t=(l.getCalendar.get_date())-(7*24*60*60)# OVERDUE
  puts "CALL serve('ugo') #{l.serve('ugo')}"
  print "books size start is 5 = #{l.getBookList().size}"
  
  puts " CALL l.check_out(1)) UPDATE Book lst  #{l.check_out(1)}"
  puts " set overdue#{l.make_overDue(1)}"
  puts "CALL l.check_out(2) ) UPDATE Book lst  and cust list #{l.check_out(2)}"
  puts " set overdue #{l.make_overDue(2)}"
  puts "CALL l.check_out(3) UPDATE Book lst  #{l.check_out(3)}"
  puts " set overdue #{l.make_overDue(3)}"
  
  print "books size should be 2 =  #{l.getBookList().size}"
  puts "CALL l.getMember()[:ugo].inspect #{l.getMember()[:ugo].inspect}"
  
  puts "CALL l.getMember()[:ugo].bookBorrowed[0].getId() #{l.getMember()[:ugo].bookBorrowed[0].getId()}"
  puts "CALL l.getMember()[:ugo].bookBorrowed[0].get_due_date #{l.getMember()[:ugo].bookBorrowed[0].get_due_date}"
  puts "CALL l.find_all_overdue_books() "; puts "#{l.find_all_overdue_books()}"
  
  #puts "CALL l.getMember()  #{ l.getMember() }"
rescue Exception => e; puts e.message ; end
  
  begin
### Issue card and serve customer
puts "### Issue card and serve _______________________________________________________"
puts "CALL issue_card gino #{l.issue_card('gino')}"
puts "CALL issue_card gino again #{l.issue_card('gino')}"
puts "CALL serve('gino') #{l.serve('gino')}"
puts "CALL serve('ugo') #{l.serve('ugo')}"
puts "CALL serve('carl') #{l.serve('carl')}"
rescue Exception => e; puts e.message ; end

begin
### Check_in and search
puts "### Check_in and search _______________________________________________"
puts "CALL l.check_out(1) #{l.check_out(1)} "
puts "CALL l.check_out(2) #{l.check_out(2)} "# it throws an exception
   
puts "CALL l.check_in(1) #{l.check_in(1)} " 
puts "CALL l.check_in(2) #{l.check_in(2)} "
puts "CALL l.check_in(3) #{l.check_in(3)} "
puts "CALL l.check_in(2) #{l.check_in(2)} "
rescue Exception => e; puts "CALL l.check_in(2) second Time"+ e.message ; end

puts "CALL l.search('   saga ArL tact  ttt1 ')"; puts "#{l.search("   saga ArL tact  ttt1 ")} " 
print "CALL l.search('   TTTT  autho ')"; print "#{l.search("   TTTT  autho ")} " 


### Check_out and Renew 
puts "#### Check_out and Renew _______________________________________________"
begin
puts "CALL check_out(book_ids 1)"; puts" #{l.check_out(1)} " 
puts "CALL check_out(book_ids 1)"; puts" #{l.check_out(1000)} " 
rescue Exception => e; puts "CALL check_out(book_ids X)"+ e.message ; end
puts "CALL check_out(book_ids 2)"; puts" #{l.check_out(2)} "  
puts "CALL check_out(book_ids 3)"; puts" #{l.check_out(3)} " 
puts "CALL check_out(book_ids 4)"; puts" #{l.check_out(4)} "
begin  puts "CALL renew(book_ids 1)"; puts" #{l.renew(1)} "; rescue Exception => e; puts "CALL check_out(book_ids X)"+ e.message ; end   
begin  puts" #{l.renew(1000)} "; rescue Exception => e; puts "CALL renew(book_ids 1000)"+ e.message ; end
 
### Close Quit open Library 
puts "#### Close Quit open Library _______________________________________________"
begin  puts" #{l.close()} "; rescue Exception => e; puts "CALL l.close()"+ e.message ; end
puts "CALL quit() #{l.quit()} " 
puts "CALL l.open() #{l.open()}"
begin  puts" #{l.open()} "; rescue Exception => e; puts "CALL l.open()"+ e.message ; end

###  Serve customer bookBorrowed find_overdue_books()
puts "#### Serve customer bookBorrowed find_overdue_books _______________________________________________"
begin puts"The custIsServe() #{l.custIsServe()}"; rescue Exception => e; puts "l.custIsServe()"+ e.message ; end
puts "CALL serve('ugo')#{l.serve('ugo')}"
puts "CALL l.getCurrentMember.name)#{l.getCurrentMember.name }"
puts "CALL l.getCurrentMember.bookBorrowed #{l.getCurrentMember.bookBorrowed}"
puts "CALL find_overdue_books() "; puts"  #{l.find_overdue_books()}"
puts "NOW I MAKE OVERDUE BOOK ";
t=(l.getCalendar.get_date())-(7*24*60*60)# OVERDUE 
puts "CALL l.check_in(1) #{l.check_in(1)} #{l.check_in(2)} #{l.check_in(3)} " 
puts "CALL l.getCurrentMember.bookBorrowed #{l.getCurrentMember.bookBorrowed}"
puts "CALL l.getBookList() #{l.getBookList()}"
puts "CALL l.getMember()[:ugo].check_out(l.getBookList()[0]) #{l.getMember()[:ugo].check_out(l.getBookList()[0])}"
puts "CALL l.getBookList()[0].check_out(t) #{l.getBookList()[0].check_out(t)}"
puts "CALL l.getMember()[:ugo].check_out(l.getBookList()[1]) #{l.getMember()[:ugo].check_out(l.getBookList()[1])}"
puts "CALL l.getBookList()[0].check_out(t) #{l.getBookList()[1].check_out(t)}"
puts "CALL find_overdue_books() "; puts"  #{l.find_overdue_books()}"

n=[]
puts "CALL serve('pep')"; puts"  #{l.serve('pep')}" 
print "CALL l.getCurrentMember.bookBorrowed "; puts "#{l.getCurrentMember.bookBorrowed}"
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
print "l.getCurrentMember.bookBorrowed "; print l.getCurrentMember.bookBorrowed.size
