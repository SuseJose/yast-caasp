require "cwm"

module Y2Hostname
  module Widgets
    class Btns < CWM::InputField
      def initialize
        textdomain "hostname"
      end

      def label
        _("Hostname Model")
      end

      def help
        _("<h3>Just write your new hostname and click on next or save</h3>")
      end
    end
  end
end
