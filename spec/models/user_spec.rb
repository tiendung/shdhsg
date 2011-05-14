require 'spec_helper'

describe User do

  before :all do
    @i = User.new; @i.save(:validate => false)
    @u = User.new; @u.save(:validate => false)
    @h = User.new; @h.save(:validate => false)
  end

  it 'lord given me an awesomness' do
    User.lord.liked(@i).first.reason.should == Settings.default_reason
  end

  it 'my init data' do
    @i.awesome.should == 1
    @i.awesomenesses.size.should == 1
    @i.credit.should == Settings.default_credit + 1
  end

  it '@i limit my credit to 2' do
    @i.credit = 2; @i.save
    @i.credit.should == 2
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
    @i.credit.should == 1

    @u.awesome.should == 2
    @u.credit.should == 4
  end
  
  it 'I like you first second time' do
    @i.like(@u, 'You are kindness')
    @i.liked?(@u, 'You  are  kindness').should == true
    @i.liked(@u).map(&:reason).sort.should == ['you are beautiful', 'you are kindness']
    @i.credit.should == 0

    @u.awesome.should == 3
    @u.credit.should == 5
  end

  it 'I cannot like you third time, I have no credits left' do
    @i.like(@u, 'I love you so much !!!').should == false
    10.times { @i.like(@u, 'a'*rand(100)).should == false }
  end
  
  it 'He like you too' do
    @h.liked?(@u, 'abc').should == false
    @h.like(@u, 'ABC')
    @u.awesome.should == 4
    @h.liked?(@u).should == true
    @h.liked(@u).map(&:reason).sort.should == ['abc']

    @u.awesome.should == 4
    @u.credit.should == 6
  end
end
