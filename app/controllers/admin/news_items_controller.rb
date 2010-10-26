class Admin::NewsItemsController < Admin::ExtishController

protected

  def after_update
    @news_categories = NewsCategory.find(params[:news_categories]) rescue []
    @resource.set_pending_news_categories @news_categories
  end

  def parse_search
    @conditions = false
  end

  def resource_class
    NewsItem
  end

  def resource_singular_path(resource)
    admin_news_item_path(resource)
  end

  def resource_plural_path
    admin_news_items_path
  end
end
