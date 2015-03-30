require 'test/unit'
require 'Library.rb'

class LibraryTest < Test::Unit::TestCase 
  def setup
    @l=Library.new()
  end  
  puts "\n__________________________________TESTING_____________________________________"
  def test_exception_on_open
    test_libIsOpen()  
  end
  # test exception right message on close 
  def test_exception_on_close
    @l.open()
    @l.close()
    expectT = false
    assert_equal(expectT, @l.getIsLibOpen(),msg="esp__________false")
    expectT2 = nil
    assert_equal(expectT2, @l.getCurrentMember(),msg="esp__________nil")
    begin
      # Call the method that should throw an exception
      @l.open()
      expectT2 = "Good night"
      assert_equal(expectT2, @l.close(), msg="esp__________Good night")
      @l.close()
    rescue Exception => e # or you can test for specific exceptions
      expect1="The library is not open."
      assert_equal(expect1, e.message)
      puts "The close library exception work OK" # The exception happened, so the test passes
      return
    end
  end
 # test exception if library is open,customer is served exeption , book overdue id and title, expect Array from overdue  , if not issue one and serve it, 
  def test_exception_on_find_overdue_books() 
    test_libIsOpen() 
    begin
     @l.custIsServe()
    rescue Exception => e # or you can test for specific exceptions
      expect1="No member is currently been served"
      assert_equal(expect1, e.message)
      puts "The custIsServe() OK" # The exception happened, so the test passes
    end 
    #@l.readFile()# make books list #######################################################
    @l.addMember(:ugo, Member.new("ugo","bbkLib"))
    @l.serve('ugo')
    # set date to be overdue on book1 VIP ####################
    due =(@l.calendar().get_date())-(7*24*60*60) 
    puts "CALL @l.getBookList()[0].check_out(due)#{@l.getBookList()[0].check_out(due)}"
    puts "CALL @l.getCurrentMember().check_out(@l.getBookList()[0])#{@l.getCurrentMember().check_out(@l.getBookList()[0])}"
    expectT = 1 
    assert_equal(expectT, @l.getBookList()[0].id() ,msg="esp__________book overdue id")   
    @l.getBookList().delete_at(0) 
    overDueArray = @l.loopBookArray(@l.getCurrentMember())
    expectT = Array
    assert_equal(expectT, @l.loopBookArray(@l.getCurrentMember()).class ,msg="expect Array")
    expectT = "bookTitle1" 
    assert_equal(expectT, overDueArray[1][0].title() ,msg="esp__________book overdue title")       
  end
  def test_libIsOpen() 
    @l.open()
    begin
     @l.libIsOpen() 
    rescue Exception => e # or you can test for specific exceptions
      expect1="The library is not open"
      assert_equal(expect1, e.message)
      puts "The libIsOpen() work OK" # The exception happened, so the test passes
    end
  end
 
# test  customer has card, if is already a member, if not issue one and serve it, 
def test_on_issue_card()
  test_libIsOpen() 
  #puts "#{@l.issue_card('rod')}"
  expectT = "Welcome rod to BBK library" 
  assert_equal(expectT, @l.issue_card('rod') ,msg="___Welcome rod to BBK library")
  expectT = "Sorry this rod already exist" 
  assert_equal(expectT, @l.issue_card('rod') ,msg="___Sorry this rod already exist")     
end
#
# test  customer has card, if not issue one and serve it
def test_on_serve()
  @l.open()  
  expectT = "Gim does not have a library card." 
  assert_equal(expectT, @l.serve('Gim') ,msg="___Gim does not have a library card.")
  @l.issue_card('Gim') 
  expectT = "Now serving Gim "
  assert_equal(expectT, @l.serve('Gim') ,msg="___Now serving Gim")   
end 
####
# test exception if no customer is served
def test_on_custIsServe()

  begin
      @l.custIsServe()
    rescue Exception => e # or you can test for specific exceptions
      expect1="No member is currently been served"
      assert_equal(expect1, e.message)
    end  

end 
# test for all exception and right message is returned if check in successfull  
def test_on_check_in()
  test_libIsOpen() 
  test_on_custIsServe() 
  @l.issue_card('ugo'); @l.serve('ugo'); @l.check_out(5);
  #puts "#{@l.getCurrentMember().bookBorrowed().size}"
  expectT = "ugo has return book id 5 " 
  assert_equal(expectT, @l.check_in(5) ,msg="___ugo has return book id 5")
  begin
    @l.check_in(3)
  rescue Exception => e # or you can test for specific exceptions
    expect1=" The current member does't have book id 3"
    assert_equal(expect1, e.message)
  end  
end   
#######################  
# test for at least 4 char, no book found, find book with search '   saga ArLc tact  ttt1 ', 
# find multiple result running '   TTTT  autho '     
def test_on_search()
  test_libIsOpen() 
  expectT = "Search string must contain at least four characters." 
  assert_equal(expectT, @l.search("bok") ,msg="___Search string must contain at least four characters.")  
  
  expectT = "No books found." 
  assert_equal(expectT, @l.search("west") ,msg="___No books found.") 
  
  expectT = "id: 4, title Contact Alien, by Author Carl Sagan" 
  assert_equal(expectT, @l.search('   saga ArLc tact  ttt1 ') ,msg="___books found.") 
  
  expectT = "id: 1, title bookTitle1, by Author author1id: 2, title bookTitle2, by Author author2id: 3, title bookTitle3, by Author author3id: 5, title bookTitle4, by Author author4"
  assert_equal(expectT, @l.search('   TTTT  autho ') ,msg="___ multiple books found.") 
end   
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
 end########### end LibraryTest
