require 'spec_helper'

describe User do

  before :all do
    @i = User.create
    @u = User.create
    @h = User.create
  end
  
  it 'just created' do
    @i.point.should == 0
    @i.awesomenesses.should == []
    @i.credit.should == Settings.default_credit
    @i.liked?(@u, '  You Are  beautiful ').should == false
    @i.liked?(@u, 'You  are  kindness').should == false
  end
  
  it 'I like you first time' do
    @i.like(@u, 'You are beautiful')
    @i.liked?(@u, 'You Are  beautiful').should == true
    @i.liked?(@u, '  You  are  kiNdneSs  ').should == false
    @i.liked(@u).map(&:reason).sort.should == ['you are beautiful']
    @u.point.should == 1
  end
  
  it 'I like you first second time' do
    @i.like(@u, 'You are kindness')
    @i.liked?(@u, 'You  are  kindness').should == true
    @i.liked(@u).map(&:reason).sort.should == ['you are beautiful', 'you are kindness']
    @u.point.should == 2
  end
  
  it 'He like you too' do
    @h.liked?(@u, 'abc').should == false
    @h.like(@u, 'ABC')
    @u.point.should == 3
    @h.liked?(@u).should == true
    @h.liked(@u).map(&:reason).sort.should == ['abc']
  end
end
