module Mongoid
  module Noteable
    extend ActiveSupport::Concern

    included do |base|
      base.field :news_count, :type => Integer, :default => 100
      base.has_many :news, :class_name => "News", :as => :noteable, :dependent => :destroy
    end

    # set how many pieces of news one user can have
    #
    # Example:
    # >> @u = User.new
    # >> @u.save
    # >> @u.set_news_limit(1000)
    # => true
    #
    # Arguments:
    #   limit => Integer

    def set_news_limit(limit)
      self.update_attribute(:news_count, limit)
    end

    # add one piece of news
    #
    # Example:
    # >> @u.add_news("I", "voted for", "Bush")
    # => nil
    #
    # Arguments:
    #   args => news objects

    def add_news(*args)
      self.news.create!(:subject => args[0].to_s, :action => args[1].to_s, :object => args[2].to_s, :headline => (args[3] == 1 ? true : false))

      if self.news.count > self.news_count
        self.news[self.news_count..-1].each do |news|
          news.destroy
        end
      end
    end

    #get all news

    def all_news
      rebuild_news(self.news.desc_created_at)
    end

    #highlighted news

    def highlight_news
      rebuild_news(self.news.by_field("headline", true))
    end

    #get all recent news

    def recent_news(time = 3600)
      rebuild_news(self.news.by_time(time))
    end

    #define 3 methods

    def method_missing(name, *args)
      if name.to_s =~ /^news_with_(subject|action|object)$/i
        rebuild_news(self.news.by_field($1, args[0]))
      else
        super
      end
    end

    private
      def rebuild_news(news_list)
        news = []
        news_list.each do |n|
          news << n.subject + ' ' + n.action + ' ' + n.object
        end
        news
      end
  end
end
