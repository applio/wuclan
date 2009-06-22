require 'date'
module TwitterFriends
  module StructModel
    module ModelCommon

      #
      # By default, take the front num_key_fields of the flattened struct
      #
      def key
        to_a[0..(num_key_fields-1)].join("-")
      end

      def fix_id!
        return if @ids_fixed
        numeric_id_fields.each{|id| self[id] = ModelCommon.zeropad_id(self[id])}
        @ids_fixed = true
      end
      def to_a
        fix_id!
        super
      end

      # ===========================================================================
      #
      # Metrics
      #
      def scrape_age
        (DateTime.now - DateTime.parse_safely(scraped_at)).to_f
      end

      def days_since_created
        (DateTime.now - DateTime.parse_safely(created_at)).to_f
      end

      # ===========================================================================
      #
      # Field conversions
      #
      # Make the data easier for batch flat-record processing
      #

      # Format for date-string conversion
      DATEFORMAT = "%Y%m%d%H%M%S"
      #
      # Convert date into flat, uniform format
      # This method is idempotent: repeated calls give same result.
      #
      def self.flatten_date dt
        begin
          DateTime.parse(dt.to_s).strftime(DATEFORMAT) if dt
        rescue ; nil ; end
      end

      #
      # Zero-pad IDs to a full 10 digits (the max digits for an unsigned 32-bit
      # integer).
      #
      # nil id will be encoded as 0.  Shit happens and we'd rather be idempotent
      # than picky.
      #
      # Note that sometime in 2010 (or sooner, depending on its growth rate: in 2008
      # Dec it was 1.8M/day) the status_id will exceed 32 bits.  Something will
      # happen then.
      # This method is idempotent: repeated calls give same result.
      #
      def self.zeropad_id id
        id ||= 0
        '%010d' % [id.to_i]
      end

      #
      # Express boolean as 1 (true) or 0 (false).  In contravention of typical ruby
      # semantics (but in a way that is more robust for wukong-like batch
      # processing), the number 0, the string '0', nil and false are all considered
      # false. (This also makes the method idempotent: repeated calls give same result.)
      #
      def self.unbooleanize bool
        case bool when 0, '0', false, nil then 0 else 1 end
      end
    end
  end
end
