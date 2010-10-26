class ExternalFeedsController < ApplicationController
  # Plural methods.
  def gets
    @resources = ExternalFeed.by_category /Observation|Artwork/
    respond_to do |format|
      format.html
    end
  end
end
