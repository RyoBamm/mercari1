class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit]
  before_action :move_to_sign_in, only: [:new]

  def index
    @ladies = Item.where(category_id: 1..140).order("RAND()").limit(4)
    @mens = Item.where(category_id: 141..260).order("created_at DESC").limit(4)
    @cosmes = Item.where(category_id: 141..260).order("created_at DESC").limit(4)
    @babies = Item.where(category_id: 261..387).order("created_at DESC").limit(4)
    @chanels = Item.where(brand_id: 1).order("created_at DESC").limit(4)
    @supremes = Item.where(brand_id: 28).limit(4)
    @nikes = Item.order("RAND()").limit(4)
  end

  def show
    @images = @item.images
  end

  def new
    @item = Item.new
    4.times { @item.images.build }  # 1つのitemにつき最大4つの画像を持たせる
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to :root
    else
      redirect_to :new_item , alert: '出品に失敗しました'
    end
  end

  def edit
  end

  def update
    item = Item.find(params[:id])
    if item.seller_id == current_user.id
      item.update(item_params) 
      redirect_to :root, notice: '編集に成功しました'
    else
      redirect_to :edit_item , alert: '編集に失敗しました'
    end
  end

  def destroy
    item = Item.find(params[:id])
    if item.seller_id == current_user.id
     item.destroy 
     redirect_to :root, notice: '商品を削除しました'
    else
      redirect_to :edit_item , alert: '編集に失敗しました'
    end
  end

  def search
    @items = Item.where('name LIKE(?)', "%#{params[:keyword]}%").limit(8)
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :text,
      :price,
      :condition,
      :shipping_payer,
      :shipping_method,
      :days_to_ship,
      :trading_status,
      :shipping_fee,
      :category_id,
      :brand_id,
      :size_id,
      :area_id,
      :seller_id,
      :buyer_id,
      images_attributes: [:id, :image, :item_id, :_destroy]
    )
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def move_to_sign_in
    redirect_to new_user_session_path unless user_signed_in?
  end
end

