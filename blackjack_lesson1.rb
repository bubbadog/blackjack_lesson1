=begin
Create application logic and then convert into code
1.  Welcome msg
begin play again loop
2.  initialize deck/shoe
3.  initialize cards
4.  iitialize player and computer hands
5.  shuffle deck (need to accomodate suit and number {'Clubs' => {(1..13)}, etc?)
begin gameplay loop
6.  deal initial 2 cards to player and dealer (add to hands)
7.  add up: check to see if dealer hit blackjack, then check if player hit blackjack
8.  begin dealing loop
9.  begin player loop
    a.  deal cards to player
    b. continue dealing until card total > 21 or player stands
    c.  if bust, dealer wins
9.  begin dealer loop
    a.  deal cards to player
    b.  continue dealing unitl card total >= 17 or > 21
    c.  if bust, player wins automatically
10. end dealing loop; compare hands
    a.  if player > dealer (and no busts), then player wins
    b.  if dealer >= player, then dealer wins
11. end gameplay loop
12 end play again loop with prompt to play again

=end

require 'pry'

def calculate_hand(cards)
  arr = cards.map {|e| e[0]}  # create and set arr to values in dealt hand

  total = 0                   # set hand to 0
  arr.each do |value|         # cycle through each value and determine value to hand
    if value == 'Ace'         # start with most restrictive case
      total += 11             # increment by 11 (high value for ace)
    elsif value.to_i == 0     # all non-integer values remaining after taking aces out
      total += 10             # face cards are all worth 10
    else
      total += value.to_i     # increment total by value of card, i.e 2-10
    end
  end


  # handle dual nature of aces
  arr.select{|n| n == "Ace"}.count.times do   # counts number of times the aces are in the hand and creates loop equal to that number
    total -= 10 if total > 21    # subtracts 10 each do/end loop (assigned from .times method)
  end
  total                       # returns total!
end

puts
puts "Welcome to Bubba's Blackjack Barn and Wafflehouse!"

# start loop here
loop do
  
  puts
  puts
    
  value = ['2','3','4','5','6','7','8','9','10', 'Jack', 'Queen', 'King', 'Ace']
  suit = ['spades', 'hearts', 'clubs', 'diamonds']

  deck =  value.product(suit)
  deck.shuffle!

  # Deal cards

  player_hand = []               # initialize hand to empty array
  dealer_hand = []

  player_hand << deck.pop        # add one card to hand
  dealer_hand << deck.pop
  player_hand << deck.pop
  dealer_hand << deck.pop

  # calculate hand - step 6 above)

  dealertotal = calculate_hand(dealer_hand)   # send hand to method to calculate score
  playertotal = calculate_hand(player_hand)

  # show hands and prompt to hit or stay (7)

  puts "The dealer has a #{dealer_hand[0][0]} and a #{dealer_hand[1][0]} for a total of: #{dealertotal}."
  puts "You have a #{player_hand[0][0]} and a #{player_hand[1][0]} for a total of: #{playertotal}."
  puts "---------------"
  puts

  # check dealer for blackjack first

  if dealertotal == 21
    puts "Dealer has blackjack!  You lose."
    exit                                      #
  end

  # check player for blackjack
  if playertotal == 21 
    puts "Blackjack - you win!!! "
    exit                                     # ends game 
  end

  while playertotal < 21
    puts "=> Do you wish to 1) hit or 2) stay?"
    hit_or_stay = gets.chomp

    if !['1','2'].include?(hit_or_stay)  # => if !['1', '2'].include?(hit_or_stay)
      puts "=> Try again: enter a 1 to hit or 2 to stay."
      puts "-------------"
      next                                        # move to next block in while loop
    end

    if hit_or_stay == '2'
      puts "You chose to stay."
      puts
      break                                       # ends while loop for player
    end

    # player hits
    hit_card = deck.pop
    puts "You drew a #{hit_card[0]}"
    player_hand << hit_card
    playertotal = calculate_hand(player_hand)
    puts "Your total is now: #{playertotal}."

    # if players hand now reaches 21
    if playertotal == 21
      puts "Very skilled - you now have 21!"
      break
    elsif playertotal > 21
      puts "Game Over!  You busted with these cards: #{player_hand.join(',')}!"
      exit
    end
  end                                             # end player's while loop

  while dealertotal < 17                          # start dealer while loop
    # hit                                         # hit first
    hit_card  = deck.pop
    puts "The dealer drew a #{hit_card[0]}."
    dealer_hand << hit_card
    dealertotal = calculate_hand(dealer_hand)
    puts "The dealer now has: #{dealertotal}."
    puts

    if dealertotal > 21  
      puts                         # after first hit if busts!
      puts "You win - dealer busted!  Bubba's kids can't go to college now."
      exit
    end
  end                                              # end dealer loop

  # compare hands and determine a winner
  puts "Dealer's cards are:"                       # create .each do/end loop for each card
  dealer_hand.each do |card|
    puts "#{card}"
  end
  puts

  puts"-------------"
  puts "Your cards are:"
  player_hand.each do |card|
    puts "#{card}"
  end
  puts

  if dealertotal > playertotal
    puts
    puts "The house wins again!  Here's a free drink - better luck next time!"
  elsif playertotal > dealertotal
    puts
    puts "You got lucky and won a game!"
  else
    puts
    puts "Unbelievable - it's a push! You each have #{playertotal}!"
  end
  puts
  puts "Play again? (Y/N)"
  break if gets.chomp.downcase != 'y'
end

puts
puts "Thanks for playing at Bubba's Blackjack Barn and Wafflehouse!"

