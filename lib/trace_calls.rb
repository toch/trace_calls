require 'trace_calls/version'
require 'trace_calls/method_call'

module TraceCalls
  def self.root
    @@root_call
  end
  def self.on
    @@root_call = nil
    scope = {}
    call_stack = []
    calls = Set.new
    trace = TracePoint.new(:call, :line, :return) do |tp|
      case tp.event
      when :return
        last_call = call_stack.pop
        call_stack.last << last_call unless last_call.is_root?
      when :call
        current_call = MethodCall.new(
          tp.method_id,
          tp.defined_class,
          tp.path,
          tp.lineno,
          call_stack.last,
          scope[:lineno]
        )
        call_stack << current_call
        @@root_call = call_stack.last if call_stack.size == 1
      when :line
        scope = {
          event: :line,
          lineno: tp.lineno,
          path: tp.path,
          class: tp.defined_class,
          method_id: tp.method_id
        }
      end
    end

    trace.enable
    yield
    trace.disable
  end
end
