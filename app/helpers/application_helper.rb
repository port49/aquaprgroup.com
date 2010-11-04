module ApplicationHelper
  def date_format(datetime)
    datetime.strftime("%m/%d/%y") unless datetime.nil?
  end
end
