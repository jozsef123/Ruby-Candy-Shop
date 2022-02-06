class Shop 
    attr_accessor :id, :junkShelf
   def initialize(id)
      @id = id
      @junkShelf = 0
   end

   def shelves
        Shelf.all.select {|shelf| shelf.shop == self}
   end

   def shelf_ids
        shelves.map {|shelf| shelf.id}
   end

   def shelf_inventory
        shelves.map {|shelf| shelf.candy_names}
   end

   def shelf_candy_count
        shelves.map {|shelf| shelf.getCandyCount}
   end

   def to_s()
   		"id: #@id"
   end

   def getId()
        @id
   end

   def setJunkShelf(junkShelf)
        @junkShelf = junkShelf
   end

   def getJunkShelf()
        @junkShelf
   end

   def getShelfCount()
        shelves.count
   end

   def addShelf(shelf, shop)
        shelf.addToShop(shop)
   end

end