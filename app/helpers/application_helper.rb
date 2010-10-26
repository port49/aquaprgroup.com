module ApplicationHelper
  def date_format(datetime)
    datetime.strftime("%m/%d/%y %I:%M%p") unless datetime.nil?
  end
end
