class User::BagsController < ApplicationController
  before_action :set_bag, only: %i[update destroy]
  before_action :set_reference, only: %i[create]

  def index
    @bags = current_user.bags
  end

  def create
    @bag = Bag.new(bag_params)
    @bag.user = current_user
    @bag.custom_size = @reference.size if @bag.custom_size.nil?
    @bag.custom_capacity = @reference.capacity if @bag.custom_capacity.nil?
    @bag.custom_weight = @reference.weight if @bag.custom_weight.nil?
    if @bag.save
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Bag created.' }
        format.js { render 'user/bags/create' }
      end
    else
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Bag not created.' }
        format.js { render 'user/bags/create' }
      end
    end
  end

  def destroy
    if @bag.destroy
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Bag destroyed.' }
        format.js { render 'user/bags/destroy' }
      end
    else
      respond_to do |format|
        format.html { redirect_to 'journeys/show', notice: 'Bag not destroyed.' }
        format.js { render 'user/bags/destroy' }
      end
    end
  end

  private

  def set_bag
    @bag = Bag.find(params[:id])
  end

  def set_reference
    @reference = BagRef.find(params[:bag][:reference_id])
  end

  def bag_params
    params.require(:bag).permit(:reference_id, :name, :custom_size, :custom_capacity, :custom_weight)
  end
end
