class ShopsController < ApplicationController

  before_action :set_shop, only: [:show, :edit, :update, :destroy]
  before_filter :shop_authorize, except: [:new, :create]

  # GET /shops
  # GET /shops.json
  def index
    @shops = Shop.all
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if find_position and @shop.save
        format.html { redirect_to @shop, notice: 'Shop was successfully created.' }
        format.json { render :show, status: :created, location: @shop }
      else
        format.html { render :new }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to @shop, notice: 'Shop was successfully updated.' }
        format.json { render :show, status: :ok, location: @shop }
      else
        format.html { render :edit }
        format.json { render json: @shop.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:email, :password, :password_confirmation, :name, :phone, :address, :pref, :city, :rang, :capability, :open_at, :close_at)
    end

    def find_position

      response = Unirest.get "http://maps.googleapis.com/maps/api/geocode/json?address="+@shop.address+","+@shop.pref+","+@shop.city, headers:{"accept" => "application/json"}
      temp = response.body

      if temp.class == "String" then
        temp.force_encoding('ASCII-8BIT')
        temp.gsub!(/\n/,'')
        temp.gsub!(/\s/,'')
        temp = JSON.parse(temp)
      end

      if temp["results"].class == "Array" then
        return false
      end

      @shop.position_x = temp["results"][0]["geometry"]["location"]["lat"].to_f
      @shop.position_y = temp["results"][0]["geometry"]["location"]["lng"].to_f

      return true
    end
end
