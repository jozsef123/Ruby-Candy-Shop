class Shelf 
    attr_accessor :id, :status, :shop
    @@all = []
	def initialize(id, status, shop)
      @id = id
      @status = status
      @shop = shop
      @@all << self
   end

   def candies
        Candy.all.select {|candy| candy.shelf == self}
   end

   def candy_names
        candies.map {|candy| candy.name}
   end

   def candy_ids
        candies.map {|candy| candy.id}
   end

   def self.all
        @@all
   end

   def to_s()
        "id: #@id, Shop #@shop"
   end

   def getId()
        @id
   end

   def getStatus()
        @status
   end

   def getCandyCount()
        candies.count
   end

   def getShop()
        @shop.getId
   end

   def removeFromShop(warehouse)
        @shop = warehouse
        @status = false
   end
end