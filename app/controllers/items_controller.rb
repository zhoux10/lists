class ItemsController < ApplicationController
  def create
    @item = current_list.items.new(item_params)

    if @item.save
      render json: @item
    else
      render json: @item.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      render json: @item
    else
      render json: @item.errors.full_messages,
             status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    render json: {}
  end

  private

  def item_params
    params.permit(:value, :content, :title, :parent_id)
  end
end
