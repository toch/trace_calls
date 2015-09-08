require_relative '../spec_helper'

def child1_method; end
def child2_method; end
def child3_method
  child1_method
  child2_method
  child1_method
  return
end
def child4_method
  child1_method
  child1_method
  child3_method
  child2_method
end

def root_method
  child4_method
  child1_method
  child3_method
  child2_method
end

describe TraceCalls do
  it 'trace the calls' do
    TraceCalls::on do
      root_method
    end
    TraceCalls::root.to_s.must_equal "+-Object::root_method\n" \
      "  +-Object::child4_method called from Object::root_method at 19\n" \
      "  | +-Object::child1_method called from Object::child4_method at 12\n" \
      "  | +-Object::child1_method called from Object::child4_method at 13\n" \
      "  | +-Object::child3_method called from Object::child4_method at 14\n" \
      "  | | +-Object::child1_method called from Object::child3_method at 6\n" \
      "  | | +-Object::child2_method called from Object::child3_method at 7\n" \
      "  | | \\-Object::child1_method called from Object::child3_method at 8\n" \
      "  | \\-Object::child2_method called from Object::child4_method at 15\n" \
      "  +-Object::child1_method called from Object::root_method at 20\n" \
      "  +-Object::child3_method called from Object::root_method at 21\n" \
      "  | +-Object::child1_method called from Object::child3_method at 6\n" \
      "  | +-Object::child2_method called from Object::child3_method at 7\n" \
      "  | \\-Object::child1_method called from Object::child3_method at 8\n" \
      "  \\-Object::child2_method called from Object::root_method at 22" \
  end

  it 'trace the calls with details' do
    TraceCalls::on do
      root_method
    end
    TraceCalls::root.to_s(detailed: true).must_equal \
      "+-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:18:Object::root_method\n" \
      "  +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:11:Object::child4_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:18:Object::root_method at 19\n" \
      "  | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:11:Object::child4_method at 12\n" \
      "  | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:11:Object::child4_method at 13\n" \
      "  | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:11:Object::child4_method at 14\n" \
      "  | | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 6\n" \
      "  | | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:4:Object::child2_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 7\n" \
      "  | | \\-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 8\n" \
      "  | \\-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:4:Object::child2_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:11:Object::child4_method at 15\n" \
      "  +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:18:Object::root_method at 20\n" \
      "  +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:18:Object::root_method at 21\n" \
      "  | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 6\n" \
      "  | +-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:4:Object::child2_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 7\n" \
      "  | \\-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:3:Object::child1_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:5:Object::child3_method at 8\n" \
      "  \\-/home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:4:Object::child2_method called from /home/toch/Code/trace_calls/spec/trace_calls/trace_calls_spec.rb:18:Object::root_method at 22"
  end
end
