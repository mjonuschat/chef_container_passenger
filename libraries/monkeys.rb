module RunitCookbook
  module Helpers
    # We don't want to wait for the service to be up
    def wait_for_service
      true
    end
  end
end
