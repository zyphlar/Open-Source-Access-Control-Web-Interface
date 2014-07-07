class CardsController < ApplicationController
  load_and_authorize_resource except: :authorize
  before_filter :authenticate_user!, except: :authorize
  
  # GET /cards
  # GET /cards.json
  def index
    #@cards = Card.all
    #authorize! :read, @cards
    @cards = @cards.sort_by{|e| e[:id]}

    if can? :read, DoorLog then
      most_active_count = 0
      runner_up_count = 0
      @most_active_card = nil
      @runner_up_card = nil
      @cards.each do |card|
        card_num_R = card.card_number.to_i(16)%32767
        card[:accesses_this_week] = DoorLog.where("key = ? AND data = ? AND created_at > ?", 'G', card_num_R, DateTime.now - 1.month).order("created_at DESC").group_by { |d| d.created_at.beginning_of_day }.count
      end
      @most_active_cards = @cards.sort{|a,b| b[:accesses_this_week] <=> a[:accesses_this_week]}
      @most_active_card = @most_active_cards[0]
      @runner_up_card = @most_active_cards[1]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    if can? :read, DoorLog then
      card_num_R = @card.card_number.to_i(16)%32767
      @door_logs = DoorLog.where('key = ? AND data = ?', "G", card_num_R).order("created_at DESC")
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @card }
    end
  end

  # PUT /cards/1/upload
  def upload
    #@card = Card.find(params[:id])
    @upload_result = @card.upload_to_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @upload_result }
    end
  end

  # PUT /cards/upload_all
  def upload_all
    @upload_result = Card.upload_all_to_door

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @upload_result }
    end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    #@card = Card.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @card }
    end
  end

  # GET /cards/1/edit
  def edit
    #@card = Card.find(params[:id])
  end

  # POST /cards
  # POST /cards.json
  def create
    #@card = Card.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to cards_url, :notice => 'Card was successfully created.' }
        format.json { render :json => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.json { render :json => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    #@card = Card.find(params[:id])

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to cards_url, :notice => 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  def authorize

    # Stop unless signed in already, OR if the supplied user/pass params are good.
    unless current_user || check_auth(params['user'],params['pass'])
      @auth = "bad_user_or_pass"
    else
      # Stop unless the user can access the door system
      unless can? :authorize, Card
        @auth = "bad_user_permissions"
        Rails.logger.warn "----------\r\nWARNING: CARD AUTH ATTEMPT DENIED. USER #{current_user.inspect}\r\n----------"
      else

        begin
          @card = Card.find(:first, :conditions => ["lower(card_number) = ?", params[:id].downcase])
          @auth = @card.inspect 
          if @card && @card.user 
            @auth = @card.user.has_certification?(params[:device])
          else
            @auth = false
          end
        rescue
          @auth = false
        end
      end
    end

    if @card && @card.user
      username = @card.user.name
    else
      username = nil
    end

    render json: [@auth, username]
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    #@card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url, :notice => 'Card successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
