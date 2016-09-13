class UsersController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  layout 'resources'

  def sort_by_cert(certs,id)
    result = 0
    certs.each do |c|
      if c.id == id
        result = 1
      end
    end
    return result
  end

  # GET /users
  # GET /users.json
  def index
    unless params[:full] # by default, show summary

      @users = @users.active.sort_by{|u| [-u.member_level, u.name.downcase] }
#@users.paying + @users.volunteer
#.joins(:payments).where("payments.date > ? OR ", (DateTime.now - 60.days)).uniq

      respond_to do |format|
        format.html { render 'summary', layout: 'resources' }
        format.json { render :json => @users }
      end

    else # show full

      case params[:sort]
      when "name"
        @users = @users.sort_by{ |u| u.name.downcase }
      when "cert"
        @users = @users.sort_by{ |u| [-sort_by_cert(u.certifications,params[:cert].to_i),u.name.downcase] }
      when "orientation"
        @users = @users.sort_by{ |u| [-u.orientation.to_i,u.name.downcase] }
      when "waiver"
        @users = @users.sort_by{ |u| [-u.contract_date.to_i,u.name.downcase] }
      when "member"
        @users = @users.sort_by{ |u| [-u.member_status.to_i,u.name.downcase] }
      when "card"
        @users = @users.sort_by{ |u| [-u.cards.count,u.name.downcase] }
      when "instructor"
        @users = @users.sort{ |a,b| [b.instructor.to_s,a.name] <=> [a.instructor.to_s,b.name] }
      when "admin"
        @users = @users.sort{ |a,b| [b.admin.to_s,a.name] <=> [a.admin.to_s,b.name] }
      else
        @users = @users.sort_by{ |u| u.name.downcase }
      end


      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @users }
      end
    end
  end

  # 'Active' users who haven't paid recently
  def inactive
    @users = @users.all.select{|u| u if u.payment_status == false }.sort_by{ |u| -u.delinquency }
  end

  # Recent user activity
  def activity
    @zombie_members = User.where('sign_in_count = 0').where('member_level > 1')
    @user_logins = User.where(:current_sign_in_at => 2.months.ago..Time.now).where('sign_in_count > 1')
    @new_users = User.where(:created_at => 3.months.ago..Date.today)
    @cardless_users = User.includes('cards').where(['users.member_level >= ?','50']).where('cards.id IS NULL')
  end

  # New members (for emailing out)
  def new_member_report
    @new_users = User.where(:created_at => 3.months.ago..Date.today).where(:hidden => false).where(['member_level >= ?','1'])
  end
 
  # GET /users/1
  # GET /users/1.json
  def show
    @payments = Payment.where(:user_id => @user.id).order('date desc').limit(10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  def compose_email
    @user = User.find(params[:user_id])
  end

  def send_email
    @user = User.find(params[:user_id])
    @subject = params[:subject]
    @body = params[:body]
    if @user.send_email(current_user,@subject,@body)
      redirect_to user_path(@user), :notice => "Email sent successfully."
    else
      flash[:alert] = "Error sending email."
      render :compose_email
    end
  end

  # GET /user_summary/1
  def user_summary
    respond_to do |format|
      format.html { render :partial => "user_summary" } # show.html.erb
      format.json { render :json => @user }
    end 
  end

  # GET /users/new
  # GET /users/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    # update oriented_by only if orientation has been set
    @user.oriented_by_id = current_user.id unless @user.orientation.blank?

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    # update oriented_by only if it's blank but the (new) orientation isn't blank
    # gotta test the params because they don't get applied til below.
    @user.oriented_by_id = current_user.id if @user.oriented_by.blank? && (!params[:user]["orientation(1i)"].blank?)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, :notice => 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/merge
  def merge_view
    @users = @users.sort_by(&:name)

    respond_to do |format|
      format.html # merge_view.html.erb
    end
  end

  # POST /users/merge
  def merge_action
    @user_to_keep = User.find(params[:user][:to_keep])
    Rails.logger.info "USER TO KEEP:"
    Rails.logger.info @user_to_keep.inspect
    @user_to_merge = User.find(params[:user][:to_merge])
    Rails.logger.info "USER TO MERGE:"
    Rails.logger.info @user_to_merge.inspect

    @user_to_keep.absorb_user(@user_to_merge)

    Rails.logger.info "RESULT:"
    Rails.logger.info @user_to_keep.inspect
    Rails.logger.info @user_to_keep.cards.inspect
    Rails.logger.info @user_to_keep.user_certifications.inspect
    Rails.logger.info @user_to_keep.payments.inspect

    respond_to do |format|
      format.html { redirect_to @user_to_keep, :notice => 'Users successfully merged.' }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, :notice => 'User successfully deleted.' }
      format.json { head :no_content }
    end
  end
end
