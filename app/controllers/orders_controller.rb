class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]


  def vieworder
    resp = JSON.parse(params[:JSONData])
    result = JSON.parse(resp['Result'])
    ap result
  end
  # MerchantID = '11940506'
  # HashKey = '9npBbx2Y38q1sFA70jWezAS4OeCVCLBM'
  # HashIV ='80okyqiBzJC1od9p'
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show 
  	
  	@MerchantID = '11940506'
  	@HashKey = '9npBbx2Y38q1sFA70jWezAS4OeCVCLBM'
  	@HashIV ='80okyqiBzJC1od9p'
  	#set_order #@order = Order.find(params[:id])
  	# 智付寶文件規定的5個欄位必須按照字母順序

	chain = "Amt=#{@order.total}&MerchantID=#{@MerchantID}&MerchantOrderNo=#{@order.id}&TimeStamp=#{@order.created_at.to_i}&Version=1.2"

	# 頭先加上 HashKey，尾再加上 HashIV ，最後以 SHA-256 加密後再轉大寫
	@check_value = Digest::SHA256.hexdigest("HashKey=#{@HashKey}&#{chain}&HashIV=#{@HashIV}").upcase
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.fetch(:order, {})
    end
end
