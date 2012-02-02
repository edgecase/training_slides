class FileIncluder
  def self.include(text)
    new.include(text)
  end

  def initialize
    @output = ""
  end

  def include(text, tag=nil)
    state = tag ? :skip : :copy
    text.each_line do |line|
      case state
      when :copy
        if line =~ /%include +"([^"]+)"( *, *(\S+))?/
          include_file($1, $3)
        elsif line =~ /%code +"([^"]+)"( *, *(\S+))?/
          include_code($1, $3)
        elsif line =~ /%\+ +(\S+)/
          # skip
        elsif line =~ /%-/
          state = :skip if tag
        else
          emit line
        end
      when :skip
        if line =~ /%\+ +(\S+)/
          state = (tag == $1) ? :copy : :skip
        end
      end
    end
    @output
  end

  def include_code(path, tag=nil)
    result = ""
    state = :copy
    open(path) { |ins|
      ins.each_line do |line|
        result << "    " << line
      end
    }
    include(result, tag)
  end

  def include_file(path, tag=nil)
    content = open(path) { |f| f.read }
    include(content)
  end

  private

  def emit(line)
    @output << line
  end
end
