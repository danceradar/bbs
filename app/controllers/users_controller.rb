# coding: utf-8
class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create, :index]
  skip_before_filter :current_user, only: [:new, :create]
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @hot_users = User.order("comments_count desc", "posts_count desc").limit(30)
    @recent_users = User.order("created_at desc").limit(30)
    @online_users = User.find(:all, :conditions => ["state = 1"])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @user_posts = @user.posts.order("created_at desc").paginate(page: params[:page], per_page: 10)
    @user_comments = @user.comments.order("created_at desc").paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "用户 #{@user.username} 成功注册." }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: "用户 #{@user.username} 的资料更新成功." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
