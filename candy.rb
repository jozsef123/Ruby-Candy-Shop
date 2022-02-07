class Candy 
    attr_accessor :name, :id, :status, :shelf
    @@all = []

	def initialize(name, id, status, not_shelved)
        @name = name
        @id = id
        @status = status
        @shelf = not_shelved
        @@all << self
   end

   def addToShelf(shelf)
        @shelf = shelf
   end

   def removeFromShelf(notShelved)
        addToShelf(notShelved)
   end

   def self.all
        @@all
   end

   def setStatus(status)
     @status = status
   end

   def getName()
      @name
   end

   def getId()
        @id
   end

   def getShelf()
        @shelf.getId
   end

   def getShop()
    @shelf.getShop()
   end

   def to_s()
   		"name: #@name, id: #@id, Shelf #@shelf"
   end
end
