module ItemHelper
include RedisHelper
  def create_item
    
    food_params = {
      name: params[:name],
      description: params[:description],
      price: params[:price],
      category: params[:category],
      restaurant_id: params[:restaurant_id]
    }

    food = Item.new(food_params)
    food.save!

    { message: 'Food item created successfully', food: food }

  rescue ActiveRecord::RecordInvalid => e
    error!({ message: e.message, errors: food.errors.full_messages }, 422)
  end

  def search_items
    page = params[:page].present? ? params[:page].to_i : 1
    limit_value = params[:page_size].present? ? params[:page_size].to_i : 20
    page_size = [limit_value, 20].min
    offset = (page - 1) * page_size
    query = params[:query]

    if query.blank?
      error!({ message: 'Search query cannot be blank' }, 422)
    end

    cache_key = "search_items/#{query}/page/#{page}/size/#{page_size}"

    # Attempt to fetch from Redis cache
    cached_items = get_redis_cache(cache_key)
    if cached_items.present?
      return { message: 'Search results', results: cached_items }
    end

    # Fetch from database if not cached
    items = Item.where("name ILIKE ?", "%#{query}%").limit(page_size).offset(offset).to_a
    if items.blank?
      error!({ message: 'No results found' }, 404)
    end

    # Cache the fetched items
    create_redis_cache(cache_key, items)

    { message: 'Search results', results: items }
  end
end
