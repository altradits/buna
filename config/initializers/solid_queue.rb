# frozen_string_literal: true

# Enable environment-configurable supervisor mode for SolidQueue.
# Defaults to :async on development/macOS to prevent Ruby 3.2 macOS fork/getaddrinfo segfaults,
# while allowing production Linux setups to run :fork via SOLID_QUEUE_MODE=fork.
Rails.application.config.to_prepare do
  if defined?(SolidQueue::Supervisor)
    module SolidQueueSupervisorModePatch
      def start(mode: nil, load_configuration_from: nil)
        mode ||= ENV.fetch("SOLID_QUEUE_MODE", "async").to_sym
        super(mode: mode, load_configuration_from: load_configuration_from)
      end
    end

    SolidQueue::Supervisor.singleton_class.prepend(SolidQueueSupervisorModePatch)

    class SolidQueue::Supervisor::AsyncSupervisor < SolidQueue::Supervisor
      def supervise
        trap("TERM") { Thread.new { stop } }
        trap("INT")  { Thread.new { stop } }

        loop do
          break if stopped? || all_threads_terminated?
          sleep 1
        end
      ensure
        stop
      end
    end
  end
end
