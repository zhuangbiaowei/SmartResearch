class ShortMemory
  def initialize
    @memory = {}
  end

  def add_mem(url, mem)
    @memory[url] = mem
  end

  def find_mem(url)
    return @memory[url]
  end

  def get_mems
    @memory.values
  end
end
