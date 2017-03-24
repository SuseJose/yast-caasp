# encoding: utf-8

# ------------------------------------------------------------------------------
# Copyright (c) 2017 SUSE LLC
#
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, contact SUSE.
#
# To contact SUSE about this file by physical or electronic mail, you may find
# current contact information at www.suse.com.
# ------------------------------------------------------------------------------

require "yast"
require "y2caasp/cfa/salt/minion_master_conf"

module Y2SystemRoleHandlers
  # Implement finish handler for the "worker" role
  class WorkerRoleFinish
    include Yast::Logger

    # Configure Salt minion
    def run
      role = ::Installation::SystemRole.find("worker_role")
      master_conf = ::Y2Caasp::CFA::MinionMasterConf.new
      master = role["controller_node"]
      begin
        master_conf.load
      rescue Errno::ENOENT
        log.info("The minion master.conf file does not exist, it will be created")
      end
      log.info("The controller node for this worker role is: #{master}")
      # FIXME: the cobblersettings lense does not support dashes in the url
      # without single quotes, we need to use a custom lense for salt conf.
      # As Salt can use also 'url' just use in case of dashed.
      master_conf.master = master.include?("-") ? "'#{master}'" : master
      master_conf.save
    end
  end
end
