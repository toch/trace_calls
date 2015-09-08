require_relative '../spec_helper'

describe TraceCalls::MethodCall do
  subject do
    TraceCalls::MethodCall.new(
      "name",
      "scope",
      "file_path",
      1,
      nil,
      1
    )
  end

  it 'is the root' do
    assert subject.is_root?
  end

  it 'is a leaf' do
    assert subject.is_leaf?
  end

  it 'has no leaves' do
    subject.leaves.must_equal [subject]
  end

  it 'has a fully qualified name' do
    "file_path:1:scope::name"
  end

  describe 'with a child' do
    let(:child) do
      TraceCalls::MethodCall.new(
        "name_child",
        "scope_child",
        "file_path_child",
        1,
        subject,
        1
      )
    end
    before do
      subject << child
    end

    it 'is not more a leaf' do
      refute subject.is_leaf?
    end

    it 'has a child that is not the root' do
      refute child.is_root?
    end

    it 'has one leaf' do
      subject.leaves.must_equal [child]
    end
  end
end
