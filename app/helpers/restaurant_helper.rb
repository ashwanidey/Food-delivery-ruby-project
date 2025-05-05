module RestaurantHelper
  include RedisHelper

  def create_new_restaurant()
    restaurant_params = {
      name: params[:name],
    }

    restaurant = Restaurant.new(restaurant_params)
  
    begin
    restaurant.save!


    { message: 'Restaurant created successfully', restaurant: restaurant }
    rescue ActiveRecord::RecordInvalid => e
      error!({ message: e.message }, 422)
    rescue => e
      error!({ message: 'Internal server error' }, 500)
    end
  end


  def get_restaurant_foods
    page = params[:page].present? ? params[:page].to_i : 1
    limit_value = params[:page_size].present? ? params[:page_size].to_i : 20
    page_size = [limit_value, 20].min
    offset = (page - 1) * page_size
    restaurant_id = params[:id].to_i


    cache_key = "restaurant_foods/#{restaurant_id}/page/#{page}/size/#{page_size}"


    cached_items = get_redis_cache(cache_key)
    if cached_items.present?
      return { message: 'All the items (from cache)', items: cached_items }
    end


    items = Item.where(restaurant_id: restaurant_id).limit(page_size).offset(offset)

    if items.any?

      create_redis_cache(cache_key, items.map(&:attributes))
      { message: 'All the items', items: items }
    else
      { message: 'Item does not exist', items: [] }
    end
  rescue => e
    error!({ message: 'Failed to get food', error: e.message }, 500)
  end

 
end
