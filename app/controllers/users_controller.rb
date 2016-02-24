require 'rubygems'
require "json"
require 'unirest'

class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter :require_login, except: [:new, :create]
 

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if !guarantee then
      render :action => 'new'
    elsif !@user.save then
      render :action => 'new'
    else
      @user = record
      redirect_to user_path(@user.id), notice: 'Login successful'
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user 
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :phone, :address, :pref, :city)
    end

    def find_position

      response = Unirest.get "http://maps.googleapis.com/maps/api/geocode/json?address="+@user.address+","+@user.pref+","+@user.city, headers:{"accept" => "application/json"}
      temp = response.body

      if temp.class == "String" then
        temp.force_encoding('ASCII-8BIT')
        temp.gsub!(/\n/,'')
        temp.gsub!(/\s/,'')
        temp = JSON.parse(temp)
      end

      if temp["results"].class == "Array" or temp["results"].size == 0 then
        return false
      end

      @user.position_x = temp["results"][0]["geometry"]["location"]["lat"].to_f
      @user.position_y = temp["results"][0]["geometry"]["location"]["lng"].to_f

      return true
    end

    def guarantee
      flag = true
      puts @user.email
      if @user.email == ""
        @user.errors.add "email","please input email"
        flag = false
      end
      if @user.password == ""
        @user.errors.add "password","please input password"
        flag = false
      end
      if !find_position
        @user.errors.add "address","this address is wrong"
        flag = false
      end
      return flag
    end

end
