require 'spec_helper'

describe User do

  before :all do
    @i = User.new; @i.save(:validate => false)
    @u = User.new; @u.save(:validate => false)
    @h = User.new; @h.save(:validate => false)
    @admin = User.new; @admin.twitter_id = Settings.dev_team.rand; @admin.save(:validate => false)
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
    @i.like(@i, 'what ever reason').should == :cannot_like_self
  end
  
  it 'I like you first time' do
    @i.like(@u, 'You are beautiful').should == true
    @i.like(@u, 'You are beautiful').should == :cannot_like_for_the_same_reason
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
    @i.like(@u, 'I love you so much !!!').should == :no_credits_left
    1.upto(10).each { |x| @i.like(@u, 'a'*x).should == :no_credits_left }
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
  
  it 'admin can give unlimited likes' do
    1.upto(100).each { |i|
      @admin.like(@u, 'ha ha'*i)
      @u.awesome.should == 4 + i
      @u.credit.should == 6 + i
      @admin.credit.should == 3
    }
  end

  it 'I cannot like you too much' do
    @i.credit = Settings.likes_limit
    @i.save
    1.upto(Settings.likes_limit - @i.liked(@u).size).each do |x|
      @i.like(@u, '$$$'*x)
    end

    @i.like(@u, '///').should == :reach_limit
  end
end
