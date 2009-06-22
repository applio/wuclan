# -*- coding: utf-8 -*-
module Wuclan
  module Request
    #
    # Processes file as a stream of objects -- the first field in each line is
    # turned into a class and used to instantiate an object using the remaining
    # fields on that line.
    #
    # See [StructRecordizer] for more.
    #
    class Streamer < Wukong::Streamer::StructStreamer
      cattr_accessor :number_of_fields_before_request
      self.number_of_fields_before_request
      #
      #
      #
      def recordize line
        StructRecordizer.recordize *line.split("\t")
      end
    end
  end
end
