module UberModel
  module Adapters

    class ConnectionTimeoutError < UberModelError; end

    class AdapterPool
      attr_reader :spec, :max_size, :timeout

      def initialize(spec)
        @spec = spec
        @instances = []
        @checked_out_instances = []
        @assigned_instances = {}
        @instance_mutex = Monitor.new
        @instance_queue = @instance_mutex.new_cond
        @max_size = 5
        @timeout = 5
      end

      def connected?
        !@instances.empty?
      end

      def instance
        @assigned_instances[current_instance_id] ||= checkout
      end

      def release_instance(with_id = current_instance_id)
        inst = @assigned_instances.delete(with_id)
        checkin inst if inst
      end

      def shutdown!
      end

      private

      def current_instance_id
        Thread.current.object_id
      end

      def checkout
        @instance_mutex.synchronize do
          loop do
            instance = if @checked_out_instances.size < @instances.size
              checkout_existing_instance
            elsif @instances.size < @max_size
              checkout_new_instance
            end
            return instance if instance

            #
            # If we're here, we didn't get a valid instance
            #
            @instance_queue.wait(@timeout)
            if @checked_out_instances.size < @instances.size
              next
            else
              clear_stale_cached_instances!
              if @max_size == @checked_out_instances.size
                raise ConnectionTimeoutError, "Could not obtain an adapter instance within #{@timeout} seconds.  The max adapter pool size is currently #{@max_size}...consider increasing it."
              end
            end
          end
        end
      end

      def checkin(inst)
        @instance_mutex.synchronize do
          @checked_out_instances.delete(inst)
          @instance_queue.signal
        end
      end

      def new_instance
        AdapterManager.registered[spec.adapter].new(spec)
      end

      def checkout_new_instance
        i = new_instance
        @instances << i
        checkout_and_verify(i)
      end

      def checkout_existing_instance
        i = (@instances - @checked_out_instances).first
        checkout_and_verify(i)
      end

      def checkout_and_verify(i)
        i.verify!
        @checked_out_instances << i
        i
      end

      def clear_stale_cached_instances!
        keys = @assigned_instances.keys - Thread.list.find_all { |t|
          t.alive?
        }.map { |thread| thread.object_id }
        keys.each do |key|
          checkin @assigned_instances[key]
          @assigned_instances.delete(key)
        end
      end
    end
  end
end
