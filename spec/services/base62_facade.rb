require 'rails_helper'

RSpec.describe Base62Facade do
  describe ".encode" do
    it "calls Base62.encode with the given id" do
      expect(Base62).to receive(:encode).with(123).and_return("abc")
      expect(Base62Facade.encode(123)).to eq("abc")
    end
  end
  
  describe ".decode" do
    it "calls Base62.decode with the given encoded string" do
      expect(Base62).to receive(:decode).with("abc").and_return(123)
      expect(Base62Facade.decode("abc")).to eq(123)
    end
  end
end
