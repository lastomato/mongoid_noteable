require 'spec_helper'

describe Mongoid::Noteable do

  describe User do

    let!(:u) { User.new }

    context "begins" do

      before do
      	u.save
      end

      it "setting news count" do
        u.news_count.should == 100
        u.set_news_limit(5)
        u.news_count.should == 5
      end

      it "adding several news" do
        u.add_news("Shannon", "published", "A Symbolic Analysis of Relay and Switching Circuits", 1)
        sleep(1)
        u.add_news("Shamir", "commented", "'Great Job!'", 0)
        sleep(1)
        u.add_news("Cover", "commented", "'Nice!'", 0)
        sleep(1)
        u.add_news("Zheng", "shouted", "'Wow!'", 0)
        sleep(1)
        u.add_news("I", "cannot understand", "what they are saying", 0)
        sleep(1)

        u.all_news.should == ["I cannot understand what they are saying", "Zheng shouted 'Wow!'", "Cover commented 'Nice!'", "Shamir commented 'Great Job!'", "Shannon published A Symbolic Analysis of Relay and Switching Circuits"]
        u.recent_news.should == ["I cannot understand what they are saying", "Zheng shouted 'Wow!'", "Cover commented 'Nice!'", "Shamir commented 'Great Job!'", "Shannon published A Symbolic Analysis of Relay and Switching Circuits"]
        u.recent_news(5400).should == ["I cannot understand what they are saying", "Zheng shouted 'Wow!'", "Cover commented 'Nice!'", "Shamir commented 'Great Job!'", "Shannon published A Symbolic Analysis of Relay and Switching Circuits"]

        u.news_with_subject("Shannon").should == ["Shannon published A Symbolic Analysis of Relay and Switching Circuits"]
        u.news_with_action("commented").should == ["Cover commented 'Nice!'", "Shamir commented 'Great Job!'"]
        u.news_with_object("'Wow!'").should == ["Zheng shouted 'Wow!'"]

        u.highlight_news.should == ["Shannon published A Symbolic Analysis of Relay and Switching Circuits"]

        u.add_news("I", "come back", "again", 0)

        u.all_news.should == ["I come back again", "I cannot understand what they are saying", "Zheng shouted 'Wow!'", "Cover commented 'Nice!'", "Shamir commented 'Great Job!'"]
      end
    end
  end
end
