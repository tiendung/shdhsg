require 'spec_helper'

describe User do

  before :all do
    @i = User.create
    @u = User.create
    @h = User.create
  end
  
  it 'just created' do
    @i.awesome.should == 0
    @i.awesomenesses.should == []
    @i.credit.should == Settings.default_credit
    @i.credit = 2; @i.save
    @i.liked?(@u, '  You Are  beautiful ').should == false
    @i.liked?(@u, 'You  are  kindness').should == false
  end

  it 'I cannot like myself :(' do
    @i.like(@i, 'what ever reason').should == false
  end
  
  it 'I like you first time' do
    @i.like(@u, 'You are beautiful')
    @i.like(@u, 'You are beautiful').should == false
    @i.liked?(@u, 'You Are  beautiful').should == true
    @i.liked?(@u, '  You  are  kiNdneSs  ').should == false
    @i.liked(@u).map(&:reason).sort.should == ['you are beautiful']
    @u.awesome.should == 1
    @i.credit.should == 1
  end
  
  it 'I like you first second time' do
    @i.like(@u, 'You are kindness')
    @i.liked?(@u, 'You  are  kindness').should == true
    @i.liked(@u).map(&:reason).sort.should == ['you are beautiful', 'you are kindness']
    @u.awesome.should == 2
    @i.credit.should == 0
  end

  it 'I cannot like you third time, I have no credits left' do
    @i.like(@u, 'I love you so much !!!').should == false
    10.times { @i.like(@u, 'a'*rand(100)).should == false }
  end
  
  it 'He like you too' do
    @h.liked?(@u, 'abc').should == false
    @h.like(@u, 'ABC')
    @u.awesome.should == 3
    @h.liked?(@u).should == true
    @h.liked(@u).map(&:reason).sort.should == ['abc']
  end
end
