class Admin::NewsCategoriesController < Admin::ExtishController

protected
  def after_update
    @news_items = NewsItem.find(params[:news_items]) rescue []
    @resource.set_pending_news_items @news_items
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    NewsCategory
  end

  def resource_singular_path(resource)
    admin_news_category_path(resource)
  end

  def resource_plural_path
    admin_news_categories_path
  end
end
