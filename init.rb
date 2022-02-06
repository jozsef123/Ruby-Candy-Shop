require "./candy.rb"
require "./shelf.rb"
require "./shop.rb"

input = '-1';
$shops = []; 
$shopCount = 0; 
$shelves = []; 
$shelfCount = 0;
$candy = [];
$candyCount = 0;
$warehouse = Shop.new(-1); # store removed shelves in the warehouse

def addNewShop()
    $shops[$shopCount] = Shop.new($shopCount);
    $shelves[$shelfCount] = Shelf.new($shelfCount, false, $shops[$shopCount]);
    $shops[$shopCount].setJunkShelf($shelfCount);
    $shopCount +=1;
    $shelfCount +=1;
end

def addNewShelf()
    if $shopCount == 0
        p "There are no shops available to add shelves to.";
    else
        p "Select shop: "
        printShops();
        shopInput = gets.to_s.chomp;
        while shopInput.to_i < 0 || shopInput.to_i >= $shopCount || checkBadInput(shopInput)
            p "Please enter a valid Shop Id: "
            shopInput = gets.to_s.chomp;
        end
        shopInput = shopInput.to_i;
        $shelves[$shelfCount] = Shelf.new($shelfCount, true, $shops[shopInput]);
        $shelfCount += 1;
    end
    puts "\n";
end

def removeShelf()
    if $shopCount == 0
        p "There are no shops available to add shelves to.";
    else
        i = 0;
        shelfFound = false;
        while i < $shelfCount and shelfFound == false
            if $shelves[i].getStatus == true
                shelfFound = true;
            end
            i+=1;
        end
        if shelfFound == false
            p "There are no shelves available to remove.";
        else
            p "Select Shelf Id to remove from: ";
            i = 0;
            while i < $shelfCount
                if $shelves[i].getStatus == true
                    p "Shelf " + $shelves[i].to_s;
                end
                i += 1;
            end
            shelfInput = gets.to_s.chomp;
            valid = false
            while valid == false
                p "Please enter a valid Shelf Id.";
                shelfInput = gets.to_s.chomp;
                if shelfInput.to_i < 0 || shelfInput.to_i >= $shelfCount
                    valid = false;
                elsif $shelves[shelfInput.to_i].getStatus == false || checkBadInput(shelfInput)
                    valid = false;
                else 
                    valid = true;
                end
            end
            shelfInput = shelfInput.to_i;
            $shelves[shelfInput].removeFromShop($warehouse);
        end 
    end
    puts "\n";
end

def addNewCandy()
    if $shopCount == 0
        p "There are no shops available to add candy to.";
    else
        p "Select Shop Id to add candy to"
        printShops();
        shopInput = gets.to_s.chomp;
        while shopInput.to_i < 0 || shopInput.to_i >= $shopCount || checkBadInput(shopInput)
            p "Please enter a valid Shop Id: ";
            shopInput = gets.to_s.chomp;
        end
        shopInput = shopInput.to_i;
        p "Enter candy name: ";
        candyName = gets.to_s.chomp;
        shelfTemp = $shops[shopInput].getJunkShelf();
        $candy[$candyCount] = Candy.new(candyName, $candyCount, $shelves[shelfTemp]);
        $candyCount +=1;
    end
    puts "\n";
end

def moveCandyToShelf() 
    if $shopCount == 0
        p "There are no shops available";
    else
        p "Enter Shop Id to move candy onto shelf";
        printShops();
        shopInput = gets.to_s.chomp;
        while shopInput.to_i < 0 || shopInput.to_i >= $shopCount || checkBadInput(shopInput)
            p "Please enter a valid Shop Id: ";
            shopInput = gets.to_s.chomp;
        end
        shopInput = shopInput.to_i;
        if $shelves[$shops[shopInput].getJunkShelf()].getCandyCount() == 0
            p "There are no unshelved candies in the shop";
        elsif $shops[shopInput].getShelfCount() < 2             # there is one shelf that is stored in back of store, check for one more 
            p "There are no available shelves in the shop";
        else
            p "Select Candy Id to move onto shelf";
            i = 0;
            while i < $shelves[$shops[shopInput].getJunkShelf()].getCandyCount()
                p "Candy Id: " + $shelves[$shops[shopInput].getJunkShelf()].candy_ids[i].to_s + 
                ", Candy name: "+ $shelves[$shops[shopInput].getJunkShelf()].candy_names[i].to_s;
                i+=1;
            end
            candyInput = gets.to_s.chomp
            while (candyInput.to_i < 0 || candyInput.to_i >= $candyCount || 
                $shelves[$shops[shopInput].getJunkShelf()].candy_ids.include?(candyInput.to_i) == false || checkBadInput(candyInput))
                p "Please enter a valid candy Id";
                candyInput = gets.to_s.chomp;
            end
            candyInput = candyInput.to_i;
            p "Select a shelf to store candy onto";
            i = 1;
            while i < $shops[shopInput].getShelfCount()
                p "Shelf Id: " + $shops[shopInput].shelf_ids[i].to_s;
                i+=1;
            end
            shelfInput = gets.to_s.chomp;
            valid = false
            while valid == false
                 p "Please enter a valid Shelf Id";
                shelfInput = gets.to_s.chomp;
                if shelfInput.to_i < 0 || shelfInput.to_i >= $shelfCount
                    valid = false
                elsif ($shelves[shelfInput.to_i].getStatus() == false || $shops[shopInput].shelf_ids.include?(shelfInput.to_i) == false ||
                    $shelves[shelfInput.to_i].getShop == -1 || checkBadInput(shelfInput))
                    valid = false
                else
                    valid = true
                end
            end
            shelfInput = shelfInput.to_i;
            $candy[candyInput].addToShelf($shelves[shelfInput]);
        end
    end
    puts "\n";
end

def moveCandyOffShelf()
    if $shopCount == 0
        p "There are no shops available";
    else
        p "Enter Shop Id to move candy onto shelf";
        printShops();
        shopInput = gets.to_s.chomp;
        while shopInput.to_i < 0 || shopInput.to_i >= $shopCount || checkBadInput(shopInput)
            p "Please enter a valid Shop Id: ";
            shopInput = gets.to_s.chomp;
        end
        shopInput = shopInput.to_i;
        # if no candies are present on a shelf
        unshelvedCount = $shelves[$shops[shopInput].getJunkShelf()].getCandyCount();
        i = 0;
        totalCount = 0;
        while i < $shops[shopInput].getShelfCount
            totalCount += $shops[shopInput].shelves[i].getCandyCount;
            i+=1;
        end
        shelvedCount = totalCount - unshelvedCount;
        if shelvedCount == 0
            p "There are no stocked candy in the shop";
        else
            p "Enter candy Id to move off shelf";
            i = 1;
            while i < $shelfCount
                if $shelves[i].getShop == shopInput
                    j = 0;
                    while j < $shelves[i].getCandyCount()
                        p "Candy Id: " + $shelves[i].candy_ids[j].to_s + ", Candy name: "+ $shelves[i].candy_names[j].to_s;
                        j+=1;
                    end
                end
                i+=1;
            end
            candyInput = gets.to_s.chomp;
            valid = false
            while valid == false
                p "Please enter a valid candy Id";
                candyInput = gets.to_s.chomp;
                if candyInput.to_i < 0 || candyInput.to_i >= $candyCount
                    valid = false
                elsif ($shelves[$shops[shopInput].getJunkShelf()].candy_ids.include?(candyInput.to_i) == true || checkBadInput(candyInput))
                    valid = false
                else 
                    valid = true
                end
            end
            candyInput = candyInput.to_i;
            $candy[candyInput].addToShelf($shelves[$shops[shopInput].getJunkShelf()]);
        end
        puts "\n";
    end
end

def listCandiesInShop()
    if $shopCount == 0
        p "No shops available to display candies";
    else
        p "Enter Shop Id to display candies";
        printShops();
        shopInput = gets.to_s.chomp;
        while shopInput.to_i < 0 || shopInput.to_i >= $shopCount || checkBadInput(shopInput)
            p "Please enter a valid Shop Id: ";
            shopInput = gets.to_s.chomp;
        end
        shopInput = shopInput.to_i;
        candyFound = false;
        tempCandyNames = [];
        i = 0;
        while i < $shelfCount
            if $shelves[i].getStatus == true and $shelves[i].getShop == shopInput and $shelves[i].getCandyCount > 0
                tempCandyNames += $shelves[i].candy_names;
                candyFound = true;
            end
            i +=1;
        end
        if candyFound == false
            p "There are no stocked candies to display in the shop";
        else
            p tempCandyNames;
        end
    end
    puts "\n"
end

def printShops()
    i = 0;
    while i < $shopCount
        p "Shop " + $shops[i].to_s();
        i +=1;
    end
end

def checkBadInput(input)
    if (input != '0') && (input.to_i.to_s != input.strip)
        return true;
    end
    return false;
end

while input != '0'
    p "1) Create a new shop"
    p "2) Create a new shelf"
    p "3) Remove a shelf"
    p "4) Add new candy to a shelf in a store"
    p "5) Move Candy from list of unshelved to a shelf"
    p "6) Move candy from list of shelves to unshelved"
    p "7) List all candies stocked in a shop"
    p "0) End program";
    p "Enter input: "
    input = gets.to_s.chomp
    puts "\n"
    if input == '1'
        addNewShop()
    elsif input == '2'
        addNewShelf()
    elsif input == '3'
        removeShelf()
    elsif input == '4'
        addNewCandy()
    elsif input == '5'
        moveCandyToShelf()
    elsif input == '6'
        moveCandyOffShelf()
    elsif input == '7'
        listCandiesInShop()
    elsif (checkBadInput(input) || input.to_i > 7)
        p "Please enter valid input..."
        puts "\n"
    end
end