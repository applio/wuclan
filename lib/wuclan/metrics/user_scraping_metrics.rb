require 'date'
module Wuclan
  module Models
    USER_SCRAPING_CONTEXTS = [:user, :friends_ids, :followers_ids, :favorites, ] # :friends, :followers, :user_timeline]
    # USER_SCRAPING_METRICS_MEMBERS = []
    # USER_SCRAPING_CONTEXTS.map do |context|
    #   USER_SCRAPING_METRICS_MEMBERS += [
    #     ["#{context}_scraped_at",    Bignum],
    #     ["#{context}_attempts",         Integer],
    #     ["#{context}_successes",     Integer],
    #     ["#{context}_failures",      String],
    #   ]
    # end
    # p USER_SCRAPING_METRICS_MEMBERS

    #
    # Workable kludge to denormalize records
    #
    #
    class UserScrapingMetrics < TypedStruct.new(
        [:id,                 Integer],
        # *USER_SCRAPING_METRICS_MEMBERS
        ["user_scraped_at",          Bignum], ["user_attempts",          Integer], ["user_successes", Integer], ["user_failures", String],
        ["friends_ids_scraped_at",   Bignum], ["friends_ids_attempts",   Integer], ["friends_ids_successes", Integer], ["friends_ids_failures", String],
        ["followers_ids_scraped_at", Bignum], ["followers_ids_attempts", Integer], ["followers_ids_successes", Integer], ["followers_ids_failures", String],
        ["favorites_scraped_at",     Bignum], ["favorites_attempts",     Integer], ["favorites_successes", Integer], ["favorites_failures", String]
        )

      def set context, attr, val
        self.send("#{context}_#{attr}=", val)
      end
      def get context, attr
        self.send("#{context}_#{attr}")
      end

      #
      # Instantiate from pig grouped output
      #
      #   user_scraping_metrics              3021 {(followers,20081228023148,2,2,0,0,0,0,0),(friends_ids,20090205064439,1,1,0,0,0,0,0),(followers_ids,20090205064439,1,1,0,0,0,0,0),(favorites,3021,1,1,0,0,0,0,0),(user,200902
      #
      def fill_from_bag scrapings_bag
        scrapings_bag.split(/\),\(/).each do |scraping|
          scraping = scraping.gsub(/^[\{\(]+/,'').gsub(/[)}]+$/,'')
          context, *vals = scraping.split(",", 5)
          next unless USER_SCRAPING_CONTEXTS.include?(context.to_sym)
          [:scraped_at, :attempts, :successes, :failures].zip(vals).each do |attr, val|
            set context, attr, val
          end
        end
        self
      end

      def self.new id, *args
        if args.length == 1
          usm = super(id)
          usm.fill_from_bag *args
          usm
        else
          super id, *args
        end
      end
    end
  end
end
