class Base62Facade
  def self.encode(id)
    Base62.encode(id)
  end

  def self.decode(id)
    Base62.decode(id)
  end
end
