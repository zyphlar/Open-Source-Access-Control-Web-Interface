class MacLogsController < ApplicationController

def index
  @mac_logs = MacLog.desc.limit(1000)
end

end
