require "cwm"
require "cwm/dialog"
require "y2hostname/widgets/btns"

module Y2Hostname
  module Dialogs
    class Main < CWM::Dialog
      def initialize
        textdomain "hostname"
      end

      def title
        _("Change your hostname")
      end

      def contents
        VBox(
          Label("Hostname Model"),
          hostname_widget
        )
      end

      def help
        "Esta es la ayuda del dialogo"
      end

      def run
        ret = super
        while ret != :next do
          log.info "El valor de retorno es #{ret}"
          ret = super
        end

        ret
      end
      
      def next_button
        _("Save")
      end

      def next_handler
        content = hostname_widget.value
        File.write("/etc/hostname",content)
        true
      end

      private

      def hostname_widget
          @hostname_widget ||= Y2Hostname::Widgets::Btns.new
      end
    end
  end
end

