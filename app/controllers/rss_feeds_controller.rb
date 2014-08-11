class RssFeedsController < ApplicationController
  # GET /rss_feeds
  # GET /rss_feeds.json
  def index
    @rss_feeds = RssFeed.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rss_feeds }
    end
  end

  # GET /rss_feeds/1
  # GET /rss_feeds/1.json
  def show
    @rss_feed = RssFeed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rss_feed }
    end
  end

  # GET /rss_feeds/new
  # GET /rss_feeds/new.json
  def new
    @rss_feed = RssFeed.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rss_feed }
    end
  end

  # GET /rss_feeds/1/edit
  def edit
    @rss_feed = RssFeed.find(params[:id])
  end

  # POST /rss_feeds
  # POST /rss_feeds.json
  def create
    @rss_feed = RssFeed.new(params[:rss_feed])

    respond_to do |format|
      if @rss_feed.save
        format.html { redirect_to @rss_feed, notice: 'Rss feed was successfully created.' }
        format.json { render json: @rss_feed, status: :created, location: @rss_feed }
      else
        format.html { render action: "new" }
        format.json { render json: @rss_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rss_feeds/1
  # PUT /rss_feeds/1.json
  def update
    @rss_feed = RssFeed.find(params[:id])

    respond_to do |format|
      if @rss_feed.update_attributes(params[:rss_feed])
        format.html { redirect_to @rss_feed, notice: 'Rss feed was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rss_feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rss_feeds/1
  # DELETE /rss_feeds/1.json
  def destroy
    @rss_feed = RssFeed.find(params[:id])
    @rss_feed.destroy

    respond_to do |format|
      format.html { redirect_to rss_feeds_url }
      format.json { head :no_content }
    end
  end
  
  def rss_read
   redirect_to "/rss_reader"
  end
  
  def rss_reader
   @rss = RssFeed.find(:all)
   rss_parent = []
   @rss.each do |r|
    # Parsing Feed URLS
    
    feed =Feedjira::Feed.fetch_and_parse(r.url)
    @entry = feed.entries
    @entry.each_with_index do |a,i|
     # pushing feed title,url,publish date to the parent array
     rss_child = [] 
     rss_child = {title: a.title, url: a.url, published: a.published}
     rss_parent << rss_child
    end
   end
   # Sorting in latest date order
   @rss_titles = rss_parent.sort { |a,b| b[:published] <=> a[:published] } 
  end
end
