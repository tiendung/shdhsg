require "spec_helper"

describe Mongoid::Criteria do

  before do
    [ Person, Post, Preference ].each(&:delete_all)
  end

  [ :update, :update_all ].each do |method|

    let!(:person) do
      Person.create(:title => "Sir", :ssn => "666-66-6666")
    end

    let!(:address_one) do
      person.addresses.create(:street => "Oranienstr")
    end

    let!(:address_two) do
      person.addresses.create(:street => "Wienerstr")
    end

    describe "##{method}" do

      context "when updating the root document" do

        context "when updating with a criteria" do

          let(:from_db) do
            Person.first
          end

          before do
            Person.where(:title => "Sir").send(method, :title => "Madam")
          end

          it "updates all the matching documents" do
            from_db.title.should == "Madam"
          end
        end

        context "when updating all directly" do

          let(:from_db) do
            Person.first
          end

          before do
            Person.send(method, :title => "Madam")
          end

          it "updates all the matching documents" do
            from_db.title.should == "Madam"
          end
        end
      end

      context "when updating an embedded document" do

        let(:from_db) do
          Person.first
        end

        before do
          Person.where(:title => "Sir").send(
            method,
            "addresses.0.city" => "Berlin"
          )
        end

        it "updates all the matching documents" do
          from_db.addresses.first.city.should == "Berlin"
        end

        it "does not update non matching documents" do
          from_db.addresses.last.city.should be_nil
        end
      end

      context "when updating a relation" do

        context "when the relation is an embeds many" do

          let(:from_db) do
            Person.first
          end

          context "when updating the relation directly" do

            before do
              person.addresses.send(method, :city => "London")
            end

            it "updates the first document" do
              from_db.addresses.first.city.should == "London"
            end

            it "updates the last document" do
              from_db.addresses.last.city.should == "London"
            end
          end

          context "when updating the relation through a criteria" do

            before do
              person.addresses.where(:street => "Oranienstr").send(
                method, :city => "Berlin"
              )
            end

            it "updates the matching documents" do
              from_db.addresses.first.city.should == "Berlin"
            end

            it "does not update non matching documents" do
              from_db.addresses.last.city.should be_nil
            end
          end
        end

        context "when the relation is a references many" do

          let(:from_db) do
            Person.first
          end

          let!(:post_one) do
            person.posts.create(:title => "First")
          end

          let!(:post_two) do
            person.posts.create(:title => "Second")
          end

          context "when updating the relation directly" do

            before do
              person.posts.send(method, :title => "London")
            end

            it "updates the first document" do
              from_db.posts.first.title.should == "London"
            end

            it "updates the last document" do
              from_db.posts.last.title.should == "London"
            end
          end

          context "when updating the relation through a criteria" do

            before do
              person.posts.where(:title => "First").send(
                method, :title => "Berlin"
              )
            end

            it "updates the matching documents" do
              from_db.posts.first.title.should == "Berlin"
            end

            it "does not update non matching documents" do
              from_db.posts.last.title.should == "Second"
            end
          end
        end

        context "when the relation is a references many to many" do

          let(:from_db) do
            Person.first
          end

          let!(:preference_one) do
            person.preferences.create(:name => "First")
          end

          let!(:preference_two) do
            person.preferences.create(:name => "Second")
          end

          context "when updating the relation directly" do

            before do
              person.preferences.send(method, :name => "London")
            end

            it "updates the first document" do
              from_db.preferences.first.name.should == "London"
            end

            it "updates the last document" do
              from_db.preferences.last.name.should == "London"
            end
          end

          context "when updating the relation through a criteria" do

            before do
              person.preferences.where(:name => "First").send(
                method, :name => "Berlin"
              )
            end

            it "updates the matching documents" do
              from_db.preferences.first.name.should == "Berlin"
            end

            it "does not update non matching documents" do
              from_db.preferences.last.name.should == "Second"
            end
          end
        end
      end
    end
  end
end
