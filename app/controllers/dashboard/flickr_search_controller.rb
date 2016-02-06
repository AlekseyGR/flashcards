module Dashboard
  class FlickrSearchController < Dashboard::BaseController
    respond_to :js

    def search
      count = 0
      @search_tag = params[:search]

      begin
        photos = if @search_tag.blank?
                   flickr.photos.getRecent(per_page: 10)
                 else
                   flickr.photos.search(text: @search_tag, per_page: 10)
                 end

        @photos = photos.map { |photo| FlickRaw.url_q(photo) }

      rescue Errno::ECONNRESET => e
        count += 1
        retry unless count > 10
        logger.fatal "tried 10 times and couldn't get #{search_tag}: #{e}"
      end
    end
  end
end
