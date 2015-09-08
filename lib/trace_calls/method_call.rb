require 'digest'

module TraceCalls
  class MethodCall
    attr_reader :name,
                :scope,
                :file_path,
                :lineno,
                :parent,
                :called_at_lineno,
                :children

    def initialize(name, scope, file_path, lineno, parent, called_at_lineno)
      @name = name
      @scope = scope
      @file_path = file_path
      @lineno = lineno
      @parent = parent ? parent : self
      @called_at_lineno = called_at_lineno
      @children = []
    end

    def is_root?
      @parent == self
    end

    def is_leaf?
      @children.empty?
    end

    def <<(method_call)
      @children << method_call
      self
    end

    def leaves
      return [self] if is_leaf?
      @children.map(&:leaves).flatten
    end

    # +-root
    #   +-child 1
    #   +-child 2
    #   \-child 3
    #     \-child 1
    def to_s(detailed: false)
      method_name_to_get_node_name = (detailed ? :fully_qualified_name : :qualified_name)
      line = ""
      line << "+-" if is_root?
      line << "#{send(method_name_to_get_node_name)}"
      line << " called from #{parent.send(method_name_to_get_node_name)} at #{called_at_lineno}" unless is_root?
      unless children.empty?
        line << "\n"
        line << children[0..-2].map{ |child| treeify_child_line(child, detailed: detailed) }.join
        line << treeify_child_line(children.last, last_child: true, detailed: detailed)
      end
      line = line[0..-2] if line[-1] == "\n"
      line
    end

    def fully_qualified_name
      "#{file_path}:#{lineno}:#{@scope}::#{@name}"
    end

    def qualified_name
      "#{@scope}::#{@name}"
    end

    def hash
      "#{parent.fully_qualified_name}\##{called_at_lineno}>#{fully_qualified_name}".hash
    end

    def eql?(other)
      other.hash == hash
    end

    private

    def treeify_child_line(child, last_child: false, detailed: false)
      anchor = (last_child ? "\\" : "+")
      child_text = ""
      child_lines = child.to_s(detailed: detailed).lines
      child_text << "  #{anchor}-" + child_lines.shift
      while not child_lines.empty? do
        child_text << "  |" + child_lines.shift[1..-1]
      end
      child_text << "\n"
    end

  end
end
