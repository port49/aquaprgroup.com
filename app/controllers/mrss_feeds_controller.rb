class MrssFeedsController < ApplicationController
  # Plural methods.
  def gets
    @resources = MrssFeed.by_category /Observation|Artwork/
    respond_to do |format|
      format.html
    end
  end
end
