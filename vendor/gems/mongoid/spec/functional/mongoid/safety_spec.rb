require "spec_helper"

describe Mongoid::Safety do

  before(:all) do
    Mongoid.autocreate_indexes = true
  end

  before do
    Person.delete_all
  end

  after do
    Mongoid.autocreate_indexes = false
  end

  context "when global safe mode is false" do

    before do
      Mongoid.persist_in_safe_mode = false
    end

    describe ".create" do

      before do
        Person.safely.create(:ssn => "432-97-1111")
      end

      context "when no error occurs" do

        it "inserts the document" do
          Person.count.should == 1
        end
      end

      context "when a mongodb error occurs" do

        it "bubbles up to the caller" do
          lambda {
            Person.safely.create(:ssn => "432-97-1111")
          }.should raise_error(Mongo::OperationFailure)
        end
      end
    end

    describe ".create!" do

      before do
        Person.safely.create!(:ssn => "432-97-1112")
      end

      context "when no error occurs" do

        it "inserts the document" do
          Person.count.should == 1
        end
      end

      context "when a mongodb error occurs" do

        it "bubbles up to the caller" do
          lambda {
            Person.safely.create!(:ssn => "432-97-1112")
          }.should raise_error(Mongo::OperationFailure)
        end
      end
    end

    describe ".save" do

      before do
        Person.safely.create(:ssn => "432-97-1113")
      end

      context "when a mongodb error occurs" do

        let(:person) do
          Person.new(:ssn => "432-97-1113")
        end

        it "bubbles up to the caller" do
          lambda {
            person.safely.save(:ssn => "432-97-1113")
          }.should raise_error(Mongo::OperationFailure)
        end
      end
    end

    describe ".save!" do

      before do
        Person.safely.create!(:ssn => "432-97-1114")
      end

      context "when a mongodb error occurs" do

        let(:person) do
          Person.new(:ssn => "432-97-1114")
        end

        it "bubbles up to the caller" do
          lambda {
            person.safely.save!(:ssn => "432-97-1113")
          }.should raise_error(Mongo::OperationFailure)
        end
      end
    end
  end
end
