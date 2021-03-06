require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Book do
  before(:each) do
    Book.delete_all
  end
  
  it "should prepare slug" do
    b = Book.new(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b.save
    b.slug.should be_eql("9780596158064-learning-python")
  end
  
  it "should prepare unique slug if one already exists" do
    b = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b1 = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b1.slug.should be_eql("9780596158064-learning-python-1")
    b2 = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b2.slug.should be_eql("9780596158064-learning-python-2")
  end
  
  it "should properly save slug if model already existed" do
    b = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b1 = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b2 = Book.create(:title => "Learning Python", :isbn => "978-0596158064", :status => 0)
    b1_slug = b1.slug
    b1.status = 1 # change one field and save
    b1.save
    b1.slug.should be_eql(b1_slug) # slug should stay the same
  end

  it "should validate isbn10" do
    Book.valid_isbn10?("83-7322-825-X").should be_eql true
    Book.valid_isbn10?("83-7322-825-0").should be_eql false
    Book.valid_isbn10?("83-7322-ABC-X").should be_eql false
  end

  it "should validate isbn13" do
    Book.valid_isbn13?("978-0596158064").should be_eql true
    Book.valid_isbn13?("978-0596158060").should be_eql false
    Book.valid_isbn13?("ABC-0596158064").should be_eql false
    Book.valid_isbn13?("978-83-246-1082-2").should be_eql true
    Book.valid_isbn13?("978-0470227800").should be_eql true
  end

end