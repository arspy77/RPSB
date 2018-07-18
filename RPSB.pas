program RPSB;

uses
	crt;


var
	option : integer;
	quit : boolean;
	wrongoption : boolean;
	sure : boolean;
	yesno : integer;
	wrongyesno : boolean;
	difficulty : integer;
	allyattack : array [1..3] of integer;
	//1 = quick
	//2 = charging 
	//3 = blocking
	//4 = inventory[1] (heal 1 HP)
	//5 = inventory[2] (deal 1 damage)
	//6 = inventory[3] (heal 2 HP)
	//7 = inventory[4] (deal 2 damage)
	enemyattack : array [1..3] of integer;
	//1 = quick
	//2 = charging 
	//3 = blocking
	//4 = inventory[1] (heal 1 HP) or Enemy Skill 1 
	//5 = inventory[2] (deal 1 damage) or Enemy Skill 2
	//6 = inventory[3] (heal 2 HP)
	//7 = inventory[4] (deal 2 damage)
	inventory : array [1..4] of integer;
	inventory2 : array [1..4] of integer;
		//winlose1 : array [1..100] of integer;
		//winlose2 : array[1..100] of integer;   //kalo vs. mode mau diperbagus estetiknya
		//battlecounter : integer;
	inititem : integer; 
	countshown : integer;
	moveshown : array [1..3] of boolean;
	
	battlefinish : boolean;
	i : integer;
	round : integer;
	allyHP : integer;
	enemyHP : integer;
	result : boolean;
	// false for defeat or player 2 win, true for victory or player 1 win
	endingfile : file of boolean;
	endingunlock : array [1..5] of boolean;
	
function trueoption(option, numberofoptions: integer) : boolean;
begin
	if (option <= numberofoptions) and (option > 0) then 
	begin
		trueoption := true;
	end
	else
	begin
		trueoption := false;
	end;
end;

procedure wrongOptionSelected(var wrongoption : boolean; option, numberofoptions: integer);
begin
	wrongoption := false;
	if not (trueoption(option, numberofoptions)) then
	begin
		writeln('Wrong option selected, please re-enter your choice.');
		wrongoption := true;
	end;
end;

procedure AreYouSure(var sure : boolean; wrongyesno : boolean; yesno : integer);
begin
	sure := false;
	repeat
		wrongyesno := false;
		writeln('Are you sure?');
		writeln('1. Yes');
		writeln('2. No');
		write('Select your answer : '); readln(yesno);
		wrongOptionSelected(wrongyesno, yesno, 2);
	until trueoption(yesno, 2);
	if yesno = 1 then
	begin
		sure := true;
	end;
end;
			
begin
	randomize;
	assign(endingfile, 'ending.dat');
	reset(endingfile);
	for i:= 1 to 5 do
	begin
		read(endingfile, endingunlock[i]);
	end;
	close(endingfile);
	repeat
		clrscr;
		writeln('Welcome to RPSB!');
		
		writeln('-MAIN MENU-');
		writeln('1. Arcade Mode');
		writeln('2. Vs. Mode (2 players)');
		writeln('3. Tutorial');
		writeln('4. Endings');
		writeln('5. Quit');
		if endingunlock[3] then
		begin
			writeln('6. Extra Hell');
		end;
		writeln('(Enter 1 for Arcade Mode, 2 for Vs. Mode, etc.)');
		
		repeat 
			wrongoption := false;
			write('Please select an option: '); readln(option);
			wrongOptionSelected(wrongoption, option, 6); 
		until trueoption(option, 6);
		
		case option of
			1 :	begin
					writeln('Do you want to view the tutorial for battling ?');
					writeln('1. Yes');
					writeln('2. No');
					repeat
						wrongyesno := false;
						write('Select your answer : '); readln(yesno);
						wrongOptionSelected(wrongyesno, yesno, 2);
					until trueoption(yesno, 2);
					if yesno = 1 then
					begin
						clrscr;
						writeln('-TUTORIAL-');
						writeln('-Win Condition-');
						writeln('Your objective in this game is to beat your opponent in a one-on-one battle.');
						writeln('You can accomplish that by using a variety of moves to reduce the health points (HP) of your opponent to 0 or lower.');
						readln;
						writeln('-Phases and Turns-');
						writeln('The Battle is broken down into 2 phases and 3 turns each round.');
						writeln('In the first phase, the Selection Phase, you select the Moves that are going to be used each turn.');
						writeln('If you are playing Arcade Mode, you can see the Moves that the enemy is going to use in 1-3 of the 3 turns according to the difficulty you have chosen.');
						writeln('In the second phase, the Execution Phase, you will see the 3 turns unfold with the Moves you have chosen.');
						readln;
						writeln('-Moves-');
						writeln('There are 2 kinds of Moves you can use in the game, Normal and Item.');
						writeln('Normal Moves are free to use and there are 3 types of it, Quick Attack, Charging Attack, and Blocking Attack.');
						writeln('Quick Attack inflict 1 damage to an enemy using Charging Attack, Charging Attack inflict 1 damage to an enemy using Blocking Attack, and Blocking Attack Inflict 1 damage to an enemy using Quick Attack.');
						writeln('Same type Normal Moves will cancel each other.');
						writeln('Item Moves uses the effect of an item you have in your inventory in exchange for the item itself.');
						writeln('Item Moves also negate the effect of Normal Moves so use them wisely!');
						writeln('In addition, enemy skills that are not Normal Moves are also considered Item Moves.'); 
						writeln('Now, try battling for yourself!');
						readln;
						
						clrscr;
						writeln('-BATTLE-');
						writeln('-Player vs Slime-');
						battlefinish := false;
						inventory[1] := 5;
						inventory[2] := 5;
						inventory[3] := 5;
						inventory[4] := 5;
						round := 0;
						allyHP := 100;
						enemyHP := 3;
						writeln('Your HP : ', allyHP);
						writeln('Enemy HP : ', enemyHP);
						writeln('Press Enter to start the battle.');
						readln;
						repeat
							writeln('Your HP : ', allyHP);
							writeln('Enemy HP : ', enemyHP);
							round += 1;
							writeln('-Round ', round, '-');
							writeln('-Selection Phase-');
							readln;
							for i:= 1 to 3 do
							begin
								randomize;
								enemyattack[i] := random(3) + 1;
								case enemyattack[i] of
									1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
									2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
									3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
								end;
							end;
							
							for i := 1 to 3 do
							begin
								
								writeln('-Turn ', i, '-');
								writeln('Select your Move:');
								writeln('1. Quick Attack');
								writeln('2. Charging Attack');
								writeln('3. Blocking Attack');
								if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
								begin
									writeln('4. Item');
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 4);
									until trueoption(option, 4);
								end
								else
								begin
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 3);
									until trueoption(option, 3);
								end;
								if option <=3 then 
								begin
									allyattack[i] := option;
								end
								else
								begin
									writeln('Select an Item:');
									writeln('1. Healing Potion 	Held : ', inventory[1]);
									writeln('2. Poison Arrow	Held : ', inventory[2]);
									writeln('3. Large Healing Potion	Held : ', inventory[3]);
									writeln('4. Poison Bullet	Held : ', inventory[4]);
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										if (inventory[option] <= 0) and (option>0) and (option<5)  then
										begin
											option += 4;
											writeln('You cannot use something you do not hold.');
										end;
										wrongOptionSelected(wrongoption, option, 4);
										
									until trueoption(option, 4);
									inventory[option] -= 1;
									allyattack[i] := option + 3;
								end;
							end;
							
							writeln('-Execution Phase-');
							readln;
							for i:= 1 to 3 do
							begin
								if (allyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := false;
									writeln('You ran out of HP.');
									writeln('-DEFEAT-');
								end
								else if (enemyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := true;
									writeln('The enemy ran out of HP.');
									writeln('-VICTORY-');
								end
								else
								begin
									case allyattack[i] of
										1 :	begin
												case enemyattack[i] of
													1 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													2 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													3 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
												end;
											end;
										2 :	begin
												case enemyattack[i] of
													2 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													3 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													1 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
												end;
											end;
										3 :	begin
												case enemyattack[i] of
													3 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													1 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													2 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
												end;
											end;
										4 :	begin
												writeln('You recovered 1 HP.');
												allyHP += 1;
											end;
										5 :	begin
												writeln('You dealt 1 damage to the enemy.');
												enemyHP -= 1;
											end;
										6 :	begin
												writeln('You recovered 2 HP.');
												allyHP += 2;
											end;
										7 :	begin
												writeln('You dealt 2 damage to the enemy.');
												enemyHP -= 2;
											end;
									end;
									readln;
								end;
							end;
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('You ran out of HP.');
								writeln('-DEFEAT-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('The enemy ran out of HP.');
								writeln('-VICTORY-');
							end;
						until battlefinish;
						readln;
						
						clrscr;
						if result then 
						begin
							writeln('Easy, right? There was no way for you to lose that battle.');
						end
						else
						begin
							writeln('Huh? You lost? Well... You must be uhh... dedicated? Whatever the case, this is truly shocking.');
							writeln('For someone like you, I have a special prize, Hidden Ending No. 5! Enjoy...');
							endingunlock[5] := true;
						end;	
						writeln('Now, time for the real Arcade mode.');
						readln;
					end;
					
					clrscr;
					writeln('-DIFFICULTY-');
					writeln('1. Beginner');
					writeln('2. Medium');
					writeln('3. Hell');
					
					repeat
						wrongoption := false;
						write('Please select a difficulty: '); readln(option);
						case option of
							1:	begin
									writeln('In Beginner, you start with 10 HP, 10 items, 2-3 enemy attacks are always shown, and recover 3 HP after each battle.');
									writeln('Beginner has 5 Stages');
								end;
							2:	begin
									writeln('In Medium, you start with 7 HP, 7 items, 1-3 enemy attacks are always shown, and recover 2 HP after each battle.');
									writeln('Medium has 6 Stages');
								end;
							3:	begin
									writeln('In Hell, you start with 5 HP, 5 items, only 1-2 enemy attack is always shown, and recover 1 HP after each battle.');
									writeln('Hell has 7 Stages');
								end;
						end;
						if trueoption(option, 3) then
						begin
							AreYouSure(sure, wrongyesno, yesno);
						end;
						
						wrongOptionSelected(wrongoption, option, 3); 
					until trueoption(option, 3) and sure = true; 
					
					difficulty := option;
					case difficulty of
						1:	begin
								allyHP := 10;
								inititem := 5;
							end;
						2:	begin
								allyHP := 7;
								inititem := 4;
							end;
						3: 	begin
								allyHP := 5;
								inititem := 3;
							end;
					end;
					writeln('Now choose the ', inititem, ' items you will use.');
					readln;
					inventory[1] := 0;
					inventory[2] := 0;
					inventory[3] := 0;
					inventory[4] := 0;
					for i:= 1 to (inititem) do
					begin
						writeln('Select Item no.', i);
						writeln('1. Healing Potion 	Held : ', inventory[1]);
						writeln('Effect: Heals 1 HP.');
						writeln('2. Poison Arrow	Held : ', inventory[2]);
						writeln('Effect: Deals 1 damage.');
						repeat
							wrongoption := false;
							write('Your Choice : '); readln(option);
							wrongOptionSelected(wrongoption, option, 2);
						until trueoption(option, 2);
						inventory[option] += 1;
					end;
					
							
					//stage 1
					clrscr;
					writeln('-STAGE 1-');
					writeln('-Player vs Slime Queen-');
					battlefinish := false;
					round := 0;
					enemyHP := 3;
					writeln('Your HP : ', allyHP);
					writeln('Enemy HP : ', enemyHP);
					writeln('Press Enter to start the battle.');
					readln;
					repeat
						randomize;
						writeln('Your HP : ', allyHP);
						writeln('Enemy HP : ', enemyHP);
						round += 1;
						writeln('-Round ', round, '-');
						writeln('-Selection Phase-');
						readln;
						
						if (difficulty = 2) then 
						begin
							countshown := random(3) + 1;
						end
						else
						begin
							countshown := random(2) + 1;
						end;
						if (difficulty = 1) then
						begin
							countshown += 1;
						end;
						randomize;
						case countshown of 
							1:	begin
									moveshown[1] := false;
									moveshown[2] := false;
									moveshown[3] := false;
									moveshown[random(3)+1] := true;
								end;
							2:	begin
									moveshown[1] := true;
									moveshown[2] := true;
									moveshown[3] := true;
									moveshown[random(3)+1] := false;
								end;
							3:	begin
									moveshown[1] := true;
									moveshown[2] := true;
									moveshown[3] := true;
								end;
						end;
						randomize;
						for i:= 1 to 3 do
						begin
							if random < 0.85 then
							begin
								enemyattack[i] := random(3) + 1;
							end
							else
							begin
								enemyattack[i] := 4;
							end;
							if moveshown[i] then
							begin
								case enemyattack[i] of
									1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
									2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
									3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
									4 : writeln('Turn ', i, ' : The enemy is preparing a Slime Bomb Attack.');
								end;
							end
							else
							begin
								writeln('Turn ', i, ' : ???');
							end;
						end;
						
						for i := 1 to 3 do
						begin
							
							writeln('-Turn ', i, '-');
							writeln('Select your Move:');
							writeln('1. Quick Attack');
							writeln('2. Charging Attack');
							writeln('3. Blocking Attack');
							if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
							begin
								writeln('4. Item');
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
							end
							else
							begin
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 3);
								until trueoption(option, 3);
							end;
							if option <=3 then 
							begin
								allyattack[i] := option;
							end
							else
							begin
								writeln('Select an Item:');
								writeln('1. Healing Potion 	Held : ', inventory[1]);
								writeln('2. Poison Arrow	Held : ', inventory[2]);
								writeln('3. Large Healing Potion	Held : ', inventory[3]);
								writeln('4. Poison Bullet	Held : ', inventory[4]);
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									if (inventory[option] <= 0) and (option>0) and (option<5)  then
									begin
										option += 4;
										writeln('You cannot use something you do not hold.');
									end;
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
								inventory[option] -= 1;
								allyattack[i] := option + 3;
							end;
						end;
						
						writeln('-Execution Phase-');
						readln;
						for i:= 1 to 3 do
						begin
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('You ran out of HP.');
								writeln('-DEFEAT-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('The enemy ran out of HP.');
								writeln('-VICTORY-');
							end
							else
							begin
								case allyattack[i] of
									1 :	begin
											case enemyattack[i] of
												1 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												2 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												3 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									2 :	begin
											case enemyattack[i] of
												2 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												3 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												1 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									3 :	begin
											case enemyattack[i] of
												3 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												1 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												2 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									4 :	begin
											writeln('You recovered 1 HP.');
											allyHP += 1;
											case enemyattack[i] of
												4 :	begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									5 :	begin
											writeln('You dealt 1 damage to the enemy.');
											enemyHP -= 1;
											if (enemyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := true;
												writeln('The enemy ran out of HP.');
												writeln('-VICTORY-');
											end
											else
											begin
												case enemyattack[i] of
													4 :	begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
												end;
											end;
										end;
									6 :	begin
											writeln('You recovered 2 HP.');
											allyHP += 2;
											case enemyattack[i] of
												4 :	begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									7 :	begin
											writeln('You dealt 2 damage to the enemy.');
											enemyHP -= 2;
											if (enemyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := true;
												writeln('The enemy ran out of HP.');
												writeln('-VICTORY-');
											end
											else
											begin
												case enemyattack[i] of
													4 :	begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
												end;
											end;
										end;
								end;
								readln;
							end;
						end;
						if (allyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := false;
							writeln('You ran out of HP.');
							writeln('-DEFEAT-');
						end
						else if (enemyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := true;
							writeln('The enemy ran out of HP.');
							writeln('-VICTORY-');
						end;
					until battlefinish;
					readln;
					
					//Stage 2 - In progress
					if result then
					begin
						clrscr;
						case difficulty of
							1 : allyHP += 3;
							2 : allyHP += 2;
							3 : allyHP += 1;
						end;
						writeln('-STAGE 2-');
						writeln('-Player vs Fairy Grandmaster-');
						battlefinish := false;
						round := 0;
						enemyHP := 5;
						writeln('Your HP : ', allyHP);
						writeln('Enemy HP : ', enemyHP);
						writeln('Press Enter to start the battle.');
						readln;
						repeat
							randomize;
							writeln('Your HP : ', allyHP);
							writeln('Enemy HP : ', enemyHP);
							round += 1;
							writeln('-Round ', round, '-');
							writeln('-Selection Phase-');
							readln;
							
							if (difficulty = 2) then 
							begin
								countshown := random(3) + 1;
							end
							else
							begin
								countshown := random(2) + 1;
							end;
							if (difficulty = 1) then
							begin
								countshown += 1;
							end;
							randomize;
							case countshown of 
								1:	begin
										moveshown[1] := false;
										moveshown[2] := false;
										moveshown[3] := false;
										moveshown[random(3)+1] := true;
									end;
								2:	begin
										moveshown[1] := true;
										moveshown[2] := true;
										moveshown[3] := true;
										moveshown[random(3)+1] := false;
									end;
								3:	begin
										moveshown[1] := true;
										moveshown[2] := true;
										moveshown[3] := true;
									end;
							end;
							randomize;
							for i:= 1 to 3 do
							begin
								if random < 0.8 then
								begin
									enemyattack[i] := random(3) + 1;
								end
								else
								begin
									enemyattack[i] := 4;
								end;
								if moveshown[i] then
								begin
									case enemyattack[i] of
										1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
										2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
										3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
										4 : writeln('Turn ', i, ' : The enemy is preparing a Healing Magic.');
									end;
								end
								else
								begin
									writeln('Turn ', i, ' : ???');
								end;
							end;
							
							for i := 1 to 3 do
							begin
								
								writeln('-Turn ', i, '-');
								writeln('Select your Move:');
								writeln('1. Quick Attack');
								writeln('2. Charging Attack');
								writeln('3. Blocking Attack');
								if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
								begin
									writeln('4. Item');
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 4);
									until trueoption(option, 4);
								end
								else
								begin
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 3);
									until trueoption(option, 3);
								end;
								if option <=3 then 
								begin
									allyattack[i] := option;
								end
								else
								begin
									writeln('Select an Item:');
									writeln('1. Healing Potion 	Held : ', inventory[1]);
									writeln('2. Poison Arrow	Held : ', inventory[2]);
									writeln('3. Large Healing Potion	Held : ', inventory[3]);
									writeln('4. Poison Bullet	Held : ', inventory[4]);
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										if (inventory[option] <= 0) and (option>0) and (option<5)  then
										begin
											option += 4;
											writeln('You cannot use something you do not hold.');
										end;
										wrongOptionSelected(wrongoption, option, 4);
									until trueoption(option, 4);
									inventory[option] -= 1;
									allyattack[i] := option + 3;
								end;
							end;
							
							writeln('-Execution Phase-');
							readln;
							for i:= 1 to 3 do
							begin
								if (allyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := false;
									writeln('You ran out of HP.');
									writeln('-DEFEAT-');
								end
								else if (enemyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := true;
									writeln('The enemy ran out of HP.');
									writeln('-VICTORY-');
								end
								else
								begin
									case allyattack[i] of
										1 :	begin
												case enemyattack[i] of
													1 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													2 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													3 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('The enemy recovered 1 HP.');
															enemyHP += 1;
														end;
												end;
											end;
										2 :	begin
												case enemyattack[i] of
													2 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													3 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													1 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('The enemy recovered 1 HP.');
															enemyHP += 1;
														end;
												end;
											end;
										3 :	begin
												case enemyattack[i] of
													3 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													1 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													2 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('The enemy recovered 1 HP.');
															enemyHP += 1;
														end;
												end;
											end;
										4 :	begin
												writeln('You recovered 1 HP.');
												allyHP += 1;
												case enemyattack[i] of
													4 :	begin
															writeln('The enemy recovered 1 HP.');
															enemyHP += 1;
														end;
												end;
											end;
										5 :	begin
												writeln('You dealt 1 damage to the enemy.');
												enemyHP -= 1;
												if (enemyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := true;
													writeln('The enemy ran out of HP.');
													writeln('-VICTORY-');
												end
												else
												begin
													case enemyattack[i] of
														4 :	begin
																writeln('The enemy recovered 1 HP.');
																enemyHP += 1;
															end;
													end;
												end;
											end;
										6 :	begin
												writeln('You recovered 2 HP.');
												allyHP += 2;
												case enemyattack[i] of
													4 :	begin
															writeln('The enemy recovered 1 HP.');
															enemyHP += 1;
														end;
												end;
											end;
										7 :	begin
												writeln('You dealt 2 damage to the enemy.');
												enemyHP -= 2;
												if (enemyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := true;
													writeln('The enemy ran out of HP.');
													writeln('-VICTORY-');
												end
												else
												begin
													case enemyattack[i] of
														4 :	begin
																writeln('The enemy recovered 1 HP.');
																enemyHP += 1;
															end;
													end;
												end;
											end;
									end;
									readln;
								end;
							end;
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('You ran out of HP.');
								writeln('-DEFEAT-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('The enemy ran out of HP.');
								writeln('-VICTORY-');
							end;
						until battlefinish;
						readln;
						
						//stage 3 - in progress
						if result then 
						begin
							clrscr;
							case difficulty of
								1 : allyHP += 3;
								2 : allyHP += 2;
								3 : allyHP += 1;
							end;
							writeln('-STAGE 3-');
							writeln('-Player vs Dragon Witch-');
							battlefinish := false;
							round := 0;
							enemyHP := 7;
							writeln('Your HP : ', allyHP);
							writeln('Enemy HP : ', enemyHP);
							writeln('Press Enter to start the battle.');
							readln;
							repeat
								randomize;
								writeln('Your HP : ', allyHP);
								writeln('Enemy HP : ', enemyHP);
								round += 1;
								writeln('-Round ', round, '-');
								writeln('-Selection Phase-');
								readln;
								
								if (difficulty = 2) then 
								begin
									countshown := random(3) + 1;
								end
								else
								begin
									countshown := random(2) + 1;
								end;
								if (difficulty = 1) then
								begin
									countshown += 1;
								end;
								randomize;
								case countshown of 
									1:	begin
											moveshown[1] := false;
											moveshown[2] := false;
											moveshown[3] := false;
											moveshown[random(3)+1] := true;
										end;
									2:	begin
											moveshown[1] := true;
											moveshown[2] := true;
											moveshown[3] := true;
											moveshown[random(3)+1] := false;
										end;
									3:	begin
											moveshown[1] := true;
											moveshown[2] := true;
											moveshown[3] := true;
										end;
								end;
								randomize;
								for i:= 1 to 3 do
								begin
									if random < 0.85 then
									begin
										enemyattack[i] := random(3) + 1;
									end
									else
									begin
										enemyattack[i] := 4;
									end;
									if moveshown[i] then
									begin
										case enemyattack[i] of
											1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
											2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
											3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
											4 : writeln('Turn ', i, ' : The enemy is preparing a Dragon Fire Attack.');
										end;
									end
									else
									begin
										writeln('Turn ', i, ' : ???');
									end;
								end;
								
								for i := 1 to 3 do
								begin
									
									writeln('-Turn ', i, '-');
									writeln('Select your Move:');
									writeln('1. Quick Attack');
									writeln('2. Charging Attack');
									writeln('3. Blocking Attack');
									if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
									begin
										writeln('4. Item');
										repeat
											wrongoption := false;
											write('Your Choice : '); readln(option);
											wrongOptionSelected(wrongoption, option, 4);
										until trueoption(option, 4);
									end
									else
									begin
										repeat
											wrongoption := false;
											write('Your Choice : '); readln(option);
											wrongOptionSelected(wrongoption, option, 3);
										until trueoption(option, 3);
									end;
									if option <=3 then 
									begin
										allyattack[i] := option;
									end
									else
									begin
										writeln('Select an Item:');
										writeln('1. Healing Potion 	Held : ', inventory[1]);
										writeln('2. Poison Arrow	Held : ', inventory[2]);
										writeln('3. Large Healing Potion	Held : ', inventory[3]);
										writeln('4. Poison Bullet	Held : ', inventory[4]);
										repeat
											wrongoption := false;
											write('Your Choice : '); readln(option);
											if (inventory[option] <= 0) and (option>0) and (option<5)  then
											begin
												option += 4;
												writeln('You cannot use something you do not hold.');
											end;
											wrongOptionSelected(wrongoption, option, 4);
										until trueoption(option, 4);
										inventory[option] -= 1;
										allyattack[i] := option + 3;
									end;
								end;
								
								writeln('-Execution Phase-');
								readln;
								for i:= 1 to 3 do
								begin
									if (allyHP <= 0) and not(battlefinish) then
									begin
										battlefinish := true;
										result := false;
										writeln('You ran out of HP.');
										writeln('-DEFEAT-');
									end
									else if (enemyHP <= 0) and not(battlefinish) then
									begin
										battlefinish := true;
										result := true;
										writeln('The enemy ran out of HP.');
										writeln('-VICTORY-');
									end
									else
									begin
										case allyattack[i] of
											1 :	begin
													case enemyattack[i] of
														1 : begin
																writeln('Nothing Happened on Turn ', i,'.');
															end;
														2 :	begin
																writeln('You dealt 1 damage to the enemy.');
																enemyHP -= 1;
															end;
														3 : begin
																writeln('You were dealt 1 damage by the enemy.');
																allyHP -= 1;
															end;
														4 :	begin
																writeln('You were dealt 2 damage by the enemy.');
																allyHP -= 2;
															end;
													end;
												end;
											2 :	begin
													case enemyattack[i] of
														2 : begin
																writeln('Nothing Happened on Turn ', i,'.');
															end;
														3 :	begin
																writeln('You dealt 1 damage to the enemy.');
																enemyHP -= 1;
															end;
														1 : begin
																writeln('You were dealt 1 damage by the enemy.');
																allyHP -= 1;
															end;
														4 :	begin
																writeln('You were dealt 2 damage by the enemy.');
																allyHP -= 2;
															end;
													end;
												end;
											3 :	begin
													case enemyattack[i] of
														3 : begin
																writeln('Nothing Happened on Turn ', i,'.');
															end;
														1 :	begin
																writeln('You dealt 1 damage to the enemy.');
																enemyHP -= 1;
															end;
														2 : begin
																writeln('You were dealt 1 damage by the enemy.');
																allyHP -= 1;
															end;
														4 :	begin
																writeln('You were dealt 2 damage by the enemy.');
																allyHP -= 2;
															end;
													end;
												end;
											4 :	begin
													writeln('You recovered 1 HP.');
													allyHP += 1;
													case enemyattack[i] of
														4 :	begin
																writeln('You were dealt 2 damage by the enemy.');
																allyHP -= 2;
															end;
													end;
												end;
											5 :	begin
													writeln('You dealt 1 damage to the enemy.');
													enemyHP -= 1;
													if (enemyHP <= 0) and not(battlefinish) then
													begin
														battlefinish := true;
														result := true;
														writeln('The enemy ran out of HP.');
														writeln('-VICTORY-');
													end
													else
													begin
														case enemyattack[i] of
															4 :	begin
																	writeln('You were dealt 2 damage by the enemy.');
																	allyHP -= 2;
																end;
														end;
													end;
												end;
											6 :	begin
													writeln('You recovered 2 HP.');
													allyHP += 2;
													case enemyattack[i] of
														4 :	begin
																writeln('You were dealt 2 damage by the enemy.');
																allyHP -= 2;
															end;
													end;
												end;
											7 :	begin
													writeln('You dealt 2 damage to the enemy.');
													enemyHP -= 2;
													if (enemyHP <= 0) and not(battlefinish) then
													begin
														battlefinish := true;
														result := true;
														writeln('The enemy ran out of HP.');
														writeln('-VICTORY-');
													end
													else
													begin
														case enemyattack[i] of
															4 :	begin
																	writeln('You were dealt 2 damage by the enemy.');
																	allyHP -= 2;
																end;
														end;
													end;
												end;
										end;
										readln;
									end;
								end;
								if (allyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := false;
									writeln('You ran out of HP.');
									writeln('-DEFEAT-');
								end
								else if (enemyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := true;
									writeln('The enemy ran out of HP.');
									writeln('-VICTORY-');
								end;
							until battlefinish;
							readln;
							//Stage 4 -In progress
							if result then
							begin
								clrscr;
								case difficulty of
									1 : allyHP += 3;
									2 : allyHP += 2;
									3 : allyHP += 1;
								end;
								writeln('-STAGE 4-');
								writeln('-Player vs Immortal Magician-');
								battlefinish := false;
								round := 0;
								enemyHP := 9;
								writeln('Your HP : ', allyHP);
								writeln('Enemy HP : ', enemyHP);
								writeln('Press Enter to start the battle.');
								readln;
								repeat
									randomize;
									writeln('Your HP : ', allyHP);
									writeln('Enemy HP : ', enemyHP);
									round += 1;
									writeln('-Round ', round, '-');
									writeln('-Selection Phase-');
									readln;
									
									if (difficulty = 2) then 
									begin
										countshown := random(3) + 1;
									end
									else
									begin
										countshown := random(2) + 1;
									end;
									if (difficulty = 1) then
									begin
										countshown += 1;
									end;
									randomize;
									case countshown of 
										1:	begin
												moveshown[1] := false;
												moveshown[2] := false;
												moveshown[3] := false;
												moveshown[random(3)+1] := true;
											end;
										2:	begin
												moveshown[1] := true;
												moveshown[2] := true;
												moveshown[3] := true;
												moveshown[random(3)+1] := false;
											end;
										3:	begin
												moveshown[1] := true;
												moveshown[2] := true;
												moveshown[3] := true;
											end;
									end;
									randomize;
									for i:= 1 to 3 do
									begin
										if random < 0.80 then
										begin
											enemyattack[i] := random(3) + 1;
										end
										else
										begin
											enemyattack[i] := 4;
										end;
										if moveshown[i] then
										begin
											case enemyattack[i] of
												1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
												2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
												3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
												4 : writeln('Turn ', i, ' : The enemy is preparing an Eternal Youth Elixir.');
											end;
										end
										else
										begin
											writeln('Turn ', i, ' : ???');
										end;
									end;
									
									for i := 1 to 3 do
									begin
										
										writeln('-Turn ', i, '-');
										writeln('Select your Move:');
										writeln('1. Quick Attack');
										writeln('2. Charging Attack');
										writeln('3. Blocking Attack');
										if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
										begin
											writeln('4. Item');
											repeat
												wrongoption := false;
												write('Your Choice : '); readln(option);
												wrongOptionSelected(wrongoption, option, 4);
											until trueoption(option, 4);
										end
										else
										begin
											repeat
												wrongoption := false;
												write('Your Choice : '); readln(option);
												wrongOptionSelected(wrongoption, option, 3);
											until trueoption(option, 3);
										end;
										if option <=3 then 
										begin
											allyattack[i] := option;
										end
										else
										begin
											writeln('Select an Item:');
											writeln('1. Healing Potion 	Held : ', inventory[1]);
											writeln('2. Poison Arrow	Held : ', inventory[2]);
											writeln('3. Large Healing Potion	Held : ', inventory[3]);
											writeln('4. Poison Bullet	Held : ', inventory[4]);
											repeat
												wrongoption := false;
												write('Your Choice : '); readln(option);
												if (inventory[option] <= 0) and (option>0) and (option<5)  then
												begin
													option += 4;
													writeln('You cannot use something you do not hold.');
												end;
												wrongOptionSelected(wrongoption, option, 4);
											until trueoption(option, 4);
											inventory[option] -= 1;
											allyattack[i] := option + 3;
										end;
									end;
									
									writeln('-Execution Phase-');
									readln;
									for i:= 1 to 3 do
									begin
										if (allyHP <= 0) and not(battlefinish) then
										begin
											battlefinish := true;
											result := false;
											writeln('You ran out of HP.');
											writeln('-DEFEAT-');
										end
										else if (enemyHP <= 0) and not(battlefinish) then
										begin
											battlefinish := true;
											result := true;
											writeln('The enemy ran out of HP.');
											writeln('-VICTORY-');
										end
										else
										begin
											case allyattack[i] of
												1 :	begin
														case enemyattack[i] of
															1 : begin
																	writeln('Nothing Happened on Turn ', i,'.');
																end;
															2 :	begin
																	writeln('You dealt 1 damage to the enemy.');
																	enemyHP -= 1;
																end;
															3 : begin
																	writeln('You were dealt 1 damage by the enemy.');
																	allyHP -= 1;
																end;
															4 :	begin
																	writeln('The enemy recovered 2 HP.');
																	enemyHP += 2;
																end;
														end;
													end;
												2 :	begin
														case enemyattack[i] of
															2 : begin
																	writeln('Nothing Happened on Turn ', i,'.');
																end;
															3 :	begin
																	writeln('You dealt 1 damage to the enemy.');
																	enemyHP -= 1;
																end;
															1 : begin
																	writeln('You were dealt 1 damage by the enemy.');
																	allyHP -= 1;
																end;
															4 :	begin
																	writeln('The enemy recovered 2 HP.');
																	enemyHP += 2;
																end;
														end;
													end;
												3 :	begin
														case enemyattack[i] of
															3 : begin
																	writeln('Nothing Happened on Turn ', i,'.');
																end;
															1 :	begin
																	writeln('You dealt 1 damage to the enemy.');
																	enemyHP -= 1;
																end;
															2 : begin
																	writeln('You were dealt 1 damage by the enemy.');
																	allyHP -= 1;
																end;
															4 :	begin
																	writeln('The enemy recovered 2 HP.');
																	enemyHP += 2;
																end;
														end;
													end;
												4 :	begin
														writeln('You recovered 1 HP.');
														allyHP += 1;
														case enemyattack[i] of
															4 :	begin
																	writeln('The enemy recovered 2 HP.');
																	enemyHP += 2;
																end;
														end;
													end;
												5 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
														if (enemyHP <= 0) and not(battlefinish) then
														begin
															battlefinish := true;
															result := true;
															writeln('The enemy ran out of HP.');
															writeln('-VICTORY-');
														end
														else
														begin
															case enemyattack[i] of
																4 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													end;
												6 :	begin
														writeln('You recovered 2 HP.');
														allyHP += 2;
														case enemyattack[i] of
															4 :	begin
																	writeln('The enemy recovered 2 HP.');
																	enemyHP += 2;
																end;
														end;
													end;
												7 :	begin
														writeln('You dealt 2 damage to the enemy.');
														enemyHP -= 2;
														if (enemyHP <= 0) and not(battlefinish) then
														begin
															battlefinish := true;
															result := true;
															writeln('The enemy ran out of HP.');
															writeln('-VICTORY-');
														end
														else
														begin
															case enemyattack[i] of
																4 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													end;
											end;
											readln;
										end;
									end;
									if (allyHP <= 0) and not(battlefinish) then
									begin
										battlefinish := true;
										result := false;
										writeln('You ran out of HP.');
										writeln('-DEFEAT-');
									end
									else if (enemyHP <= 0) and not(battlefinish) then
									begin
										battlefinish := true;
										result := true;
										writeln('The enemy ran out of HP.');
										writeln('-VICTORY-');
									end;
								until battlefinish;
								readln;
								//Stage 5 - in progress
								if result then
								begin
									clrscr;
									case difficulty of
										1 : allyHP += 3;
										2 : allyHP += 2;
										3 : allyHP += 1;
									end;
									writeln('-STAGE 5-');
									writeln('-Player vs Ancient Evil Spirit-');
									battlefinish := false;
									round := 0;
									enemyHP := 10;
									writeln('Your HP : ', allyHP);
									writeln('Enemy HP : ', enemyHP);
									writeln('Press Enter to start the battle.');
									readln;
									repeat
										randomize;
										writeln('Your HP : ', allyHP);
										writeln('Enemy HP : ', enemyHP);
										round += 1;
										writeln('-Round ', round, '-');
										writeln('-Selection Phase-');
										readln;
										
										if (difficulty = 2) then 
										begin
											countshown := random(3) + 1;
										end
										else
										begin
											countshown := random(2) + 1;
										end;
										if (difficulty = 1) then
										begin
											countshown += 1;
										end;
										randomize;
										case countshown of 
											1:	begin
													moveshown[1] := false;
													moveshown[2] := false;
													moveshown[3] := false;
													moveshown[random(3)+1] := true;
												end;
											2:	begin
													moveshown[1] := true;
													moveshown[2] := true;
													moveshown[3] := true;
													moveshown[random(3)+1] := false;
												end;
											3:	begin
													moveshown[1] := true;
													moveshown[2] := true;
													moveshown[3] := true;
												end;
										end;
										randomize;
										for i:= 1 to 3 do
										begin
											if random < 0.75 then
											begin
												enemyattack[i] := random(3) + 1;
											end
											else
											begin
												enemyattack[i] := random(2) + 4;
											end;
											if moveshown[i] then
											begin
												case enemyattack[i] of
													1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
													2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
													3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
													4 : writeln('Turn ', i, ' : The enemy is preparing a Thousand Years Old Grudge.');
													5 : writeln('Turn ', i, ' : The enemy is preparing an Ancient Healing Ritual.');
												end;
											end
											else
											begin
												writeln('Turn ', i, ' : ???');
											end;
										end;
										
										for i := 1 to 3 do
										begin
											
											writeln('-Turn ', i, '-');
											writeln('Select your Move:');
											writeln('1. Quick Attack');
											writeln('2. Charging Attack');
											writeln('3. Blocking Attack');
											if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
											begin
												writeln('4. Item');
												repeat
													wrongoption := false;
													write('Your Choice : '); readln(option);
													wrongOptionSelected(wrongoption, option, 4);
												until trueoption(option, 4);
											end
											else
											begin
												repeat
													wrongoption := false;
													write('Your Choice : '); readln(option);
													wrongOptionSelected(wrongoption, option, 3);
												until trueoption(option, 3);
											end;
											if option <=3 then 
											begin
												allyattack[i] := option;
											end
											else
											begin
												writeln('Select an Item:');
												writeln('1. Healing Potion 	Held : ', inventory[1]);
												writeln('2. Poison Arrow	Held : ', inventory[2]);
												writeln('3. Large Healing Potion	Held : ', inventory[3]);
												writeln('4. Poison Bullet	Held : ', inventory[4]);
												repeat
													wrongoption := false;
													write('Your Choice : '); readln(option);
													if (inventory[option] <= 0) and (option>0) and (option<5)  then
													begin
														option += 4;
														writeln('You cannot use something you do not hold.');
													end;
													wrongOptionSelected(wrongoption, option, 4);
												until trueoption(option, 4);
												inventory[option] -= 1;
												allyattack[i] := option + 3;
											end;
										end;
										
										writeln('-Execution Phase-');
										readln;
										for i:= 1 to 3 do
										begin
											if (allyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := false;
												writeln('You ran out of HP.');
												writeln('-DEFEAT-');
											end
											else if (enemyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := true;
												writeln('The enemy ran out of HP.');
												writeln('-VICTORY-');
											end
											else
											begin
												case allyattack[i] of
													1 :	begin
															case enemyattack[i] of
																1 : begin
																		writeln('Nothing Happened on Turn ', i,'.');
																	end;
																2 :	begin
																		writeln('You dealt 1 damage to the enemy.');
																		enemyHP -= 1;
																	end;
																3 : begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																4 :	begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																5 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													2 :	begin
															case enemyattack[i] of
																2 : begin
																		writeln('Nothing Happened on Turn ', i,'.');
																	end;
																3 :	begin
																		writeln('You dealt 1 damage to the enemy.');
																		enemyHP -= 1;
																	end;
																1 : begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																4 :	begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																5 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													3 :	begin
															case enemyattack[i] of
																3 : begin
																		writeln('Nothing Happened on Turn ', i,'.');
																	end;
																1 :	begin
																		writeln('You dealt 1 damage to the enemy.');
																		enemyHP -= 1;
																	end;
																2 : begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																4 :	begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																5 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													4 :	begin
															writeln('You recovered 1 HP.');
															allyHP += 1;
															case enemyattack[i] of
																4 :	begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																5 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													5 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
															if (enemyHP <= 0) and not(battlefinish) then
															begin
																battlefinish := true;
																result := true;
																writeln('The enemy ran out of HP.');
																writeln('-VICTORY-');
															end
															else
															begin
																case enemyattack[i] of
																	4 :	begin
																			writeln('You were dealt 1 damage by the enemy.');
																			allyHP -= 1;
																		end;
																	5 :	begin
																			writeln('The enemy recovered 2 HP.');
																			enemyHP += 2;
																		end;
																end;
															end;
														end;
													6 :	begin
															writeln('You recovered 2 HP.');
															allyHP += 2;
															case enemyattack[i] of
																4 :	begin
																		writeln('You were dealt 1 damage by the enemy.');
																		allyHP -= 1;
																	end;
																5 :	begin
																		writeln('The enemy recovered 2 HP.');
																		enemyHP += 2;
																	end;
															end;
														end;
													7 :	begin
															writeln('You dealt 2 damage to the enemy.');
															enemyHP -= 2;
															if (enemyHP <= 0) and not(battlefinish) then
															begin
																battlefinish := true;
																result := true;
																writeln('The enemy ran out of HP.');
																writeln('-VICTORY-');
															end
															else
															begin
																case enemyattack[i] of
																	4 :	begin
																			writeln('You were dealt 1 damage by the enemy.');
																			allyHP -= 1;
																		end;
																	5 :	begin
																			writeln('The enemy recovered 2 HP.');
																			enemyHP += 2;
																		end;	
																end;
															end;
														end;
												end;
												readln;
											end;
										end;
										if (allyHP <= 0) and not(battlefinish) then
										begin
											battlefinish := true;
											result := false;
											writeln('You ran out of HP.');
											writeln('-DEFEAT-');
										end
										else if (enemyHP <= 0) and not(battlefinish) then
										begin
											battlefinish := true;
											result := true;
											writeln('The enemy ran out of HP.');
											writeln('-VICTORY-');
										end;
									until battlefinish;
									readln;
									if result then
									begin
										if (difficulty = 1) then
										begin
											clrscr;
											writeln('Congratulations for clearing the game on Beginner.');
											writeln('Now is time for you to challange yourself to even greater heights.');
											endingunlock[1] := true;
											readln;
										end
										else
										begin
											//stage 6 in progress
											clrscr;
											case difficulty of
												2 : allyHP += 2;
												3 : allyHP += 1;
											end;
											writeln('-STAGE 6-');
											writeln('-Player vs Vampire Princess-');
											battlefinish := false;
											round := 0;
											enemyHP := 12;
											writeln('Your HP : ', allyHP);
											writeln('Enemy HP : ', enemyHP);
											writeln('Press Enter to start the battle.');
											readln;
											repeat
												randomize;
												writeln('Your HP : ', allyHP);
												writeln('Enemy HP : ', enemyHP);
												round += 1;
												writeln('-Round ', round, '-');
												writeln('-Selection Phase-');
												readln;
												
												if (difficulty = 2) then 
												begin
													countshown := random(3) + 1;
												end
												else
												begin
													countshown := random(2) + 1;
												end;
												randomize;
												case countshown of 
													1:	begin
															moveshown[1] := false;
															moveshown[2] := false;
															moveshown[3] := false;
															moveshown[random(3)+1] := true;
														end;
													2:	begin
															moveshown[1] := true;
															moveshown[2] := true;
															moveshown[3] := true;
															moveshown[random(3)+1] := false;
														end;
													3:	begin
															moveshown[1] := true;
															moveshown[2] := true;
															moveshown[3] := true;
														end;
												end;
												randomize;
												for i:= 1 to 3 do
												begin
													if random < 0.725 then
													begin
														enemyattack[i] := random(3) + 1;
													end
													else
													begin
														enemyattack[i] := random(2) + 4;
													end;
													if moveshown[i] then
													begin
														case enemyattack[i] of
															1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
															2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
															3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
															4 : writeln('Turn ', i, ' : The enemy is preparing a Bloodsucking Attack.');
															5 : writeln('Turn ', i, ' : The enemy is preparing a Compulsion Attack.');
														end;
													end
													else
													begin
														writeln('Turn ', i, ' : ???');
													end;
												end;
												
												for i := 1 to 3 do
												begin
													
													writeln('-Turn ', i, '-');
													writeln('Select your Move:');
													writeln('1. Quick Attack');
													writeln('2. Charging Attack');
													writeln('3. Blocking Attack');
													if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
													begin
														writeln('4. Item');
														repeat
															wrongoption := false;
															write('Your Choice : '); readln(option);
															wrongOptionSelected(wrongoption, option, 4);
														until trueoption(option, 4);
													end
													else
													begin
														repeat
															wrongoption := false;
															write('Your Choice : '); readln(option);
															wrongOptionSelected(wrongoption, option, 3);
														until trueoption(option, 3);
													end;
													if option <=3 then 
													begin
														allyattack[i] := option;
													end
													else
													begin
														writeln('Select an Item:');
														writeln('1. Healing Potion 	Held : ', inventory[1]);
														writeln('2. Poison Arrow	Held : ', inventory[2]);
														writeln('3. Large Healing Potion	Held : ', inventory[3]);
														writeln('4. Poison Bullet	Held : ', inventory[4]);
														repeat
															wrongoption := false;
															write('Your Choice : '); readln(option);
															if (inventory[option] <= 0) and (option>0) and (option<5)  then
															begin
																option += 4;
																writeln('You cannot use something you do not hold.');
															end;
															wrongOptionSelected(wrongoption, option, 4);
														until trueoption(option, 4);
														inventory[option] -= 1;
														allyattack[i] := option + 3;
													end;
												end;
												
												writeln('-Execution Phase-');
												readln;
												for i:= 1 to 3 do
												begin
													if (allyHP <= 0) and not(battlefinish) then
													begin
														battlefinish := true;
														result := false;
														writeln('You ran out of HP.');
														writeln('-DEFEAT-');
													end
													else if (enemyHP <= 0) and not(battlefinish) then
													begin
														battlefinish := true;
														result := true;
														writeln('The enemy ran out of HP.');
														writeln('-VICTORY-');
													end
													else
													begin
														case allyattack[i] of
															1 :	begin
																	case enemyattack[i] of
																		1 : begin
																				writeln('Nothing Happened on Turn ', i,'.');
																			end;
																		2 :	begin
																				writeln('You dealt 1 damage to the enemy.');
																				enemyHP -= 1;
																			end;
																		3 : begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																		4 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				writeln('The enemy recovered 1 HP.');
																				allyHP -= 1;
																				enemyHP += 1;
																			end;
																		5 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																	end;
																end;
															2 :	begin
																	case enemyattack[i] of
																		2 : begin
																				writeln('Nothing Happened on Turn ', i,'.');
																			end;
																		3 :	begin
																				writeln('You dealt 1 damage to the enemy.');
																				enemyHP -= 1;
																			end;
																		1 : begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																		4 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				writeln('The enemy recovered 1 HP.');
																				allyHP -= 1;
																				enemyHP += 1;
																			end;
																		5 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																	end;
																end;
															3 :	begin
																	case enemyattack[i] of
																		3 : begin
																				writeln('Nothing Happened on Turn ', i,'.');
																			end;
																		1 :	begin
																				writeln('You dealt 1 damage to the enemy.');
																				enemyHP -= 1;
																			end;
																		2 : begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																		4 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				writeln('The enemy recovered 1 HP.');
																				allyHP -= 1;
																				enemyHP += 1;
																			end;
																		5 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																	end;
																end;
															4 :	begin
																	writeln('You recovered 1 HP.');
																	allyHP += 1;
																	case enemyattack[i] of
																		4 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				writeln('The enemy recovered 1 HP.');
																				allyHP -= 1;
																				enemyHP += 1;
																			end;
																		5 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																	end;
																end;
															5 :	begin
																	writeln('You dealt 1 damage to the enemy.');
																	enemyHP -= 1;
																	if (enemyHP <= 0) and not(battlefinish) then
																	begin
																		battlefinish := true;
																		result := true;
																		writeln('The enemy ran out of HP.');
																		writeln('-VICTORY-');
																	end
																	else
																	begin
																		case enemyattack[i] of
																			4 :	begin
																					writeln('You were dealt 1 damage by the enemy.');
																					writeln('The enemy recovered 1 HP.');
																					allyHP -= 1;
																					enemyHP += 1;
																				end;
																			5 :	begin
																					writeln('You were dealt 1 damage by the enemy.');
																					allyHP -= 1;
																				end;
																		end;
																	end;
																end;
															6 :	begin
																	writeln('You recovered 2 HP.');
																	allyHP += 2;
																	case enemyattack[i] of
																		4 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				writeln('The enemy recovered 1 HP.');
																				allyHP -= 1;
																				enemyHP += 1;
																			end;
																		5 :	begin
																				writeln('You were dealt 1 damage by the enemy.');
																				allyHP -= 1;
																			end;
																	end;
																end;
															7 :	begin
																	writeln('You dealt 2 damage to the enemy.');
																	enemyHP -= 2;
																	if (enemyHP <= 0) and not(battlefinish) then
																	begin
																		battlefinish := true;
																		result := true;
																		writeln('The enemy ran out of HP.');
																		writeln('-VICTORY-');
																	end
																	else
																	begin
																		case enemyattack[i] of
																			4 :	begin
																					writeln('You were dealt 1 damage by the enemy.');
																					writeln('The enemy recovered 1 HP.');
																					allyHP -= 1;
																					enemyHP += 1;
																				end;
																			5 :	begin
																					writeln('You were dealt 1 damage by the enemy.');
																					allyHP -= 1;
																				end;
																		end;
																	end;
																end;
														end;
														readln;
													end;
												end;
												if (allyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := false;
													writeln('You ran out of HP.');
													writeln('-DEFEAT-');
												end
												else if (enemyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := true;
													writeln('The enemy ran out of HP.');
													writeln('-VICTORY-');
												end;
											until battlefinish;
											readln;
											if result then
											begin
												if (difficulty = 2) then
												begin
													clrscr;
													writeln('Congratulations for clearing the game on Medium.');
													writeln('Are you ready to face the challange that lies in the depths of hell itself ?');
													endingunlock[2] := true;
													readln;
												end
												else
												begin
													//stage7
													clrscr;
													allyHP += 2;
													writeln('-STAGE 7-');
													writeln('-Player vs Heiress of Doom-');
													battlefinish := false;
													round := 0;
													enemyHP := 15;
													writeln('Your HP : ', allyHP);
													writeln('Enemy HP : ', enemyHP);
													writeln('Press Enter to start the battle.');
													readln;
													repeat
														randomize;
														writeln('Your HP : ', allyHP);
														writeln('Enemy HP : ', enemyHP);
														round += 1;
														writeln('-Round ', round, '-');
														writeln('-Selection Phase-');
														readln;
														
													
														countshown := random(2) + 1;
														
														randomize;
														case countshown of 
															1:	begin
																	moveshown[1] := false;
																	moveshown[2] := false;
																	moveshown[3] := false;
																	moveshown[random(3)+1] := true;
																end;
															2:	begin
																	moveshown[1] := true;
																	moveshown[2] := true;
																	moveshown[3] := true;
																	moveshown[random(3)+1] := false;
																end;
															3:	begin
																	moveshown[1] := true;
																	moveshown[2] := true;
																	moveshown[3] := true;
																end;
														end;
														randomize;
														for i:= 1 to 3 do
														begin
															if random < 0.7 then
															begin
																enemyattack[i] := random(3) + 1;
															end
															else
															begin
																enemyattack[i] := random(2) + 4;
															end;
															if moveshown[i] then
															begin
																case enemyattack[i] of
																	1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
																	2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
																	3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
																	4 : writeln('Turn ', i, ' : The enemy is preparing The Cursed Light of Ruin.');
																	5 : writeln('Turn ', i, ' : The enemy is preparing The Holy Light of Rejuvenation.');
																end;
															end
															else
															begin
																writeln('Turn ', i, ' : ???');
															end;
														end;
														
														for i := 1 to 3 do
														begin
															
															writeln('-Turn ', i, '-');
															writeln('Select your Move:');
															writeln('1. Quick Attack');
															writeln('2. Charging Attack');
															writeln('3. Blocking Attack');
															if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
															begin
																writeln('4. Item');
																repeat
																	wrongoption := false;
																	write('Your Choice : '); readln(option);
																	wrongOptionSelected(wrongoption, option, 4);
																until trueoption(option, 4);
															end
															else
															begin
																repeat
																	wrongoption := false;
																	write('Your Choice : '); readln(option);
																	wrongOptionSelected(wrongoption, option, 3);
																until trueoption(option, 3);
															end;
															if option <=3 then 
															begin
																allyattack[i] := option;
															end
															else
															begin
																writeln('Select an Item:');
																writeln('1. Healing Potion 	Held : ', inventory[1]);
																writeln('2. Poison Arrow	Held : ', inventory[2]);
																writeln('3. Large Healing Potion	Held : ', inventory[3]);
																writeln('4. Poison Bullet	Held : ', inventory[4]);
																repeat
																	wrongoption := false;
																	write('Your Choice : '); readln(option);
																	if (inventory[option] <= 0) and (option>0) and (option<5)  then
																	begin
																		option += 4;
																		writeln('You cannot use something you do not hold.');
																	end;
																	wrongOptionSelected(wrongoption, option, 4);
																until trueoption(option, 4);
																inventory[option] -= 1;
																allyattack[i] := option + 3;
															end;
														end;
														
														writeln('-Execution Phase-');
														readln;
														for i:= 1 to 3 do
														begin
															if (allyHP <= 0) and not(battlefinish) then
															begin
																battlefinish := true;
																result := false;
																writeln('You ran out of HP.');
																writeln('-DEFEAT-');
															end
															else if (enemyHP <= 0) and not(battlefinish) then
															begin
																battlefinish := true;
																result := true;
																writeln('The enemy ran out of HP.');
																writeln('-VICTORY-');
															end
															else
															begin
																case allyattack[i] of
																	1 :	begin
																			case enemyattack[i] of
																				1 : begin
																						writeln('Nothing Happened on Turn ', i,'.');
																					end;
																				2 :	begin
																						writeln('You dealt 1 damage to the enemy.');
																						enemyHP -= 1;
																					end;
																				3 : begin
																						writeln('You were dealt 1 damage by the enemy.');
																						allyHP -= 1;
																					end;
																				4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																					end;
																				5 : begin
																						writeln('The enemy recovered 2 HP');
																						enemyHP += 2;
																					end;
																			end;
																		end;
																	2 :	begin
																			case enemyattack[i] of
																				2 : begin
																						writeln('Nothing Happened on Turn ', i,'.');
																					end;
																				3 :	begin
																						writeln('You dealt 1 damage to the enemy.');
																						enemyHP -= 1;
																					end;
																				1 : begin
																						writeln('You were dealt 1 damage by the enemy.');
																						allyHP -= 1;
																					end;
																				4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																					end;
																				5 : begin
																						writeln('The enemy recovered 2 HP');
																						enemyHP += 2;
																					end;
																			end;
																		end;
																	3 :	begin
																			case enemyattack[i] of
																				3 : begin
																						writeln('Nothing Happened on Turn ', i,'.');
																					end;
																				1 :	begin
																						writeln('You dealt 1 damage to the enemy.');
																						enemyHP -= 1;
																					end;
																				2 : begin
																						writeln('You were dealt 1 damage by the enemy.');
																						allyHP -= 1;
																					end;
																				4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																					end;
																				5 : begin
																						writeln('The enemy recovered 2 HP');
																						enemyHP += 2;
																					end;
																			end;
																		end;
																	4 :	begin
																			writeln('You recovered 1 HP.');
																			allyHP += 1;
																			case enemyattack[i] of
																				4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																					end;
																				5 : begin
																						writeln('The enemy recovered 2 HP');
																						enemyHP += 2;
																					end;
																			end;
																		end;
																	5 :	begin
																			writeln('You dealt 1 damage to the enemy.');
																			enemyHP -= 1;
																			if (enemyHP <= 0) and not(battlefinish) then
																			begin
																				battlefinish := true;
																				result := true;
																				writeln('The enemy ran out of HP.');
																				writeln('-VICTORY-');
																			end
																			else
																			begin
																				case enemyattack[i] of
																					4 :	begin
																							writeln('You were dealt 2 damage by the enemy.');
																							allyHP -= 2;
																						end;
																					5 : begin
																							writeln('The enemy recovered 2 HP');
																							enemyHP += 2;
																						end;
																				end;
																			end;
																		end;
																	6 :	begin
																			writeln('You recovered 2 HP.');
																			allyHP += 2;
																			case enemyattack[i] of
																				4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																					end;
																				5 : begin
																						writeln('The enemy recovered 2 HP');
																						enemyHP += 2;
																					end;
																			end;
																		end;
																	7 :	begin
																			writeln('You dealt 2 damage to the enemy.');
																			enemyHP -= 2;
																			if (enemyHP <= 0) and not(battlefinish) then
																			begin
																				battlefinish := true;
																				result := true;
																				writeln('The enemy ran out of HP.');
																				writeln('-VICTORY-');
																			end
																			else
																			begin
																				case enemyattack[i] of
																					4 :	begin
																						writeln('You were dealt 2 damage by the enemy.');
																						allyHP -= 2;
																						end;
																					5 : begin
																							writeln('The enemy recovered 2 HP');
																							enemyHP += 2;
																						end;
																				end;
																			end;
																		end;
																end;
																readln;
															end;
														end;
														if (allyHP <= 0) and not(battlefinish) then
														begin
															battlefinish := true;
															result := false;
															writeln('You ran out of HP.');
															writeln('-DEFEAT-');
														end
														else if (enemyHP <= 0) and not(battlefinish) then
														begin
															battlefinish := true;
															result := true;
															writeln('The enemy ran out of HP.');
															writeln('-VICTORY-');
														end;
													until battlefinish;
													readln;
													if result then
													begin
														clrscr;
														writeln('Congratulations for clearing the game on Hell! I am honestly impressed.');
														writeln('Be sure to clear the extra stage too.');
														endingunlock[3] := true;
														readln;
													end
													else
													begin
														clrscr;
														writeln('-GAME OVER-');
														writeln('Better luck next time.');
													end;
												end;
											end
											else
											begin
												clrscr;
												writeln('-GAME OVER-');
												writeln('Better luck next time.');
											end;
										end;
									end
									else
									begin
										clrscr;
										writeln('-GAME OVER-');
										writeln('Better luck next time.');
									end;
								end
								else
								begin
									clrscr;
									writeln('-GAME OVER-');
									writeln('Better luck next time.');
								end;	
							end
							else
							begin
								clrscr;
								writeln('-GAME OVER-');
								writeln('Better luck next time.');
							end;
						end
						else
						begin
							clrscr;
							writeln('-GAME OVER-');
							writeln('Better luck next time.');
						end;
					end
					else
					begin
						clrscr;
						writeln('-GAME OVER-');
						writeln('Better luck next time.');
					end;
				end;
			2:	begin
					clrscr;
					writeln('-VERSUS MODE-');
					writeln('Welcome to Vs. Mode');
					writeln('This Mode is a bit different from single player mode because you need 2 people and you cannot see any move the enemy will make in a round.');
					writeln('Before we start a battle, decide who will be player 1 and 2.');
					writeln('After deciding, first pick items to use before starting a battle.');
					writeln('Decide the number of items for player 1 from 1 to 3. Player 2 will always have 1 more item than player 1.');
					repeat 
						wrongoption := false;
						write('Item for player 1 : '); readln(option);
						wrongOptionSelected(wrongoption, option, 3); 
					until trueoption(option, 3);
					inititem := option;
					clrscr;
					writeln('Press enter when only player 1 is looking at the screen.');
					readln;
					inventory[1] := 0;
					inventory[2] := 0;
					inventory[3] := 0;
					inventory[4] := 0;
					for i:= 1 to (inititem-1) do
					begin
						writeln('Select Item no.', i);
						writeln('1. Healing Potion 	Held : ', inventory[1]);
						writeln('Effect: Heals 1 HP.');
						writeln('2. Poison Arrow	Held : ', inventory[2]);
						writeln('Effect: Deals 1 damage.');
						repeat
							wrongoption := false;
							write('Your Choice : '); readln(option);
							wrongOptionSelected(wrongoption, option, 2);
						until trueoption(option, 2);
						inventory[option] += 1;
					end;
					writeln('Select Item no.', inititem);
					writeln('1. Large Healing Potion	Held : ', inventory[3]);
					writeln('Effect: Heals 2 HP.');
					writeln('2. Poison Bullet	Held : ', inventory[4]);
					writeln('Effect: Deals 2 damage.');
					repeat
						wrongoption := false;
						write('Your Choice : '); readln(option);
						wrongOptionSelected(wrongoption, option, 2);
					until trueoption(option, 2);
					inventory[option+2] += 1;
			
					clrscr;
					writeln('Press enter when only player 2 is looking at the screen.');
					readln;
					inventory2[1] := 0;
					inventory2[2] := 0;
					inventory2[3] := 0;
					inventory2[4] := 0;
					for i:= 1 to inititem do
					begin
						writeln('Select Item no.', i);
						writeln('1. Healing Potion 	Held : ', inventory2[1]);
						writeln('Effect: Heals 1 HP.');
						writeln('2. Poison Arrow	Held : ', inventory2[2]);
						writeln('Effect: Deals 1 damage.');
						repeat
							wrongoption := false;
							write('Your Choice : '); readln(option);
							wrongOptionSelected(wrongoption, option, 2);
						until trueoption(option, 2);
						inventory2[option] += 1;
					end;
					writeln('Select Item no.', (inititem+1));
					writeln('1. Large Healing Potion	Held : ', inventory2[3]);
					writeln('Effect: Heals 2 HP.');
					writeln('2. Poison Bullet	Held : ', inventory2[4]);
					writeln('Effect: Deals 2 damage.');
					repeat
						wrongoption := false;
						write('Your Choice : '); readln(option);
						wrongOptionSelected(wrongoption, option, 2);
					until trueoption(option, 2);
					inventory2[option+2] += 1;
						
					clrscr;
					writeln('Now, Decide the number of lives for both you from 1 to 9.');
					repeat 
						wrongoption := false;
						write('Item for player 1 : '); readln(option);
						wrongOptionSelected(wrongoption, option, 9); 
					until trueoption(option, 9);
					allyHP := option;
					enemyHP := option;
					writeln('-BATTLE-');
					writeln('-Player 1 vs Player 2-');
					battlefinish := false;
					round := 0;
					writeln('Player 1 HP : ', allyHP);
					writeln('Player 2 HP : ', enemyHP);
					writeln('Press Enter to start the battle.');
					readln;
					repeat
						writeln('Player 1 HP : ', allyHP);
						writeln('Player 2 HP : ', enemyHP);
						round += 1;
						writeln('-Round ', round, '-');
						writeln('-Selection Phase-');
						readln;
						//player 1
						clrscr;
						writeln('Press enter when only player 1 is looking at the screen.');
						for i := 1 to 3 do
						begin
							
							writeln('-Turn ', i, '-');
							writeln('Select Your Move:');
							writeln('1. Quick Attack');
							writeln('2. Charging Attack');
							writeln('3. Blocking Attack');
							if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
							begin
								writeln('4. Item');
								repeat
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
							end
							else
							begin
								repeat
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 3);
								until trueoption(option, 3);
							end;
							if option <=3 then 
							begin
								allyattack[i] := option;
							end
							else
							begin
								writeln('Select an Item:');
								writeln('1. Healing Potion 	Held : ', inventory[1]);
								writeln('2. Poison Arrow	Held : ', inventory[2]);
								writeln('3. Large Healing Potion	Held : ', inventory[3]);
								writeln('4. Poison Bullet	Held : ', inventory[4]);
								repeat
									write('Your Choice : '); readln(option);
									if (inventory[option] <= 0) and (option>0) and (option<5)  then
									begin
										option += 4;
										writeln('You cannot use something you do not hold.');
									end;
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
								inventory[option] -= 1;
								allyattack[i] := option + 3;
							end;
						end;
						//player 2
						clrscr;
						writeln('Press enter when only player 2 is looking at the screen.');
						for i := 1 to 3 do
						begin
							
							writeln('-Turn ', i, '-');
							writeln('Select Your Move:');
							writeln('1. Quick Attack');
							writeln('2. Charging Attack');
							writeln('3. Blocking Attack');
							if (inventory2[1] > 0) or (inventory2[2] > 0) or (inventory2[3] > 0) or (inventory2[4] > 0) then
							begin
								writeln('4. Item');
								repeat
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
							end
							else
							begin
								repeat
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 3);
								until trueoption(option, 3);
							end;
							if option <=3 then 
							begin
								enemyattack[i] := option;
							end
							else
							begin
								writeln('Select an Item:');
								writeln('1. Healing Potion 	Held : ', inventory2[1]);
								writeln('2. Poison Arrow	Held : ', inventory2[2]);
								writeln('3. Large Healing Potion	Held : ', inventory2[3]);
								writeln('4. Poison Bullet	Held : ', inventory2[4]);
								repeat
									write('Your Choice : '); readln(option);
									if (inventory2[option] <= 0) and (option>0) and (option<5)  then
									begin
										option += 4;
										writeln('You cannot use something you do not hold.');
									end;
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
								inventory2[option] -= 1;
								enemyattack[i] := option + 3;
							end;
						end;
						clrscr;
						//player 1 and 2
						writeln('-Execution Phase-');
						writeln('Both Players are free to see this phase.');
						readln;
						for i:= 1 to 3 do
						begin
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('Player 1 ran out of HP.');
								writeln('-PLAYER 2 VICTORY-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('Player 2 ran out of HP.');
								writeln('-PLAYER 1 VICTORY-');
							end
							else
							begin
								case allyattack[i] of
									1 :	begin
											case enemyattack[i] of
												1 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												2 :	begin
														writeln('Player 1 dealt 1 damage to Player 2.');
														enemyHP -= 1;
													end;
												3 : begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('Player 2 recovered  1 HP.');
														enemyHP += 1;
													end;
												5 :	begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												6 :	begin
														writeln('Player 2 recovered 2 HP.');
														enemyHP += 2;
													end;
												7 :	begin
														writeln('Player 2 dealt 2 damage to Player 1.');
														allyHP -= 2;
													end;
											end;
										end;
									2 :	begin
											case enemyattack[i] of
												2 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												3 :	begin
														writeln('Player 1 dealt 1 damage to Player 2.');
														enemyHP -= 1;
													end;
												1 : begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('Player 2 recovered  1 HP.');
														enemyHP += 1;
													end;
												5 :	begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												6 :	begin
														writeln('Player 2 recovered 2 HP.');
														enemyHP += 2;
													end;
												7 :	begin
														writeln('Player 2 dealt 2 damage to Player 1.');
														allyHP -= 2;
													end;
											end;
										end;
									3 :	begin
											case enemyattack[i] of
												3 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												1 :	begin
														writeln('Player 1 dealt 1 damage to Player 2.');
														enemyHP -= 1;
													end;
												2 : begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												4 :	begin
														writeln('Player 2 recovered  1 HP.');
														enemyHP += 1;
													end;
												5 :	begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												6 :	begin
														writeln('Player 2 recovered 2 HP.');
														enemyHP += 2;
													end;
												7 :	begin
														writeln('Player 2 dealt 2 damage to Player 1.');
														allyHP -= 2;
													end;
											end;
										end;
									4 :	begin
											writeln('Player 1 recovered 1 HP.');
											allyHP += 1;
											case enemyattack[i] of
												4 :	begin
														writeln('Player 2 recovered  1 HP.');
														enemyHP += 1;
													end;
												5 :	begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												6 :	begin
														writeln('Player 2 recovered 2 HP.');
														enemyHP += 2;
													end;
												7 :	begin
														writeln('Player 2 dealt 2 damage to Player 1.');
														allyHP -= 2;
													end;
											end;
										end;
									5 :	begin
											writeln('Player 1 dealt 1 damage to Player 2.');
											enemyHP -= 1;
											if (enemyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := true;
												writeln('Player 2 ran out of HP.');
												writeln('-PLAYER 1 VICTORY-');
											end
											else
											begin
												case enemyattack[i] of
													4 :	begin
															writeln('Player 2 recovered  1 HP.');
															enemyHP += 1;
														end;
													5 :	begin
															writeln('Player 2 dealt 1 damage to Player 1.');
															allyHP -= 1;
														end;
													6 :	begin
															writeln('Player 2 recovered 2 HP.');
															enemyHP += 2;
														end;
													7 :	begin
															writeln('Player 2 dealt 2 damage to Player 1.');
															allyHP -= 2;
														end;
												end;
											end;
										end;
									6 :	begin
											writeln('Player 1 recovered 2 HP.');
											allyHP += 2;
											case enemyattack[i] of
												4 :	begin
														writeln('Player 2 recovered  1 HP.');
														enemyHP += 1;
													end;
												5 :	begin
														writeln('Player 2 dealt 1 damage to Player 1.');
														allyHP -= 1;
													end;
												6 :	begin
														writeln('Player 2 recovered 2 HP.');
														enemyHP += 2;
													end;
												7 :	begin
														writeln('Player 2 dealt 2 damage to Player 1.');
														allyHP -= 2;
													end;
											end;
										end;
									7 :	begin
											writeln('Player 1 dealt 2 damage to Player 2.');
											enemyHP -= 2;
											if (enemyHP <= 0) and not(battlefinish) then
											begin
												battlefinish := true;
												result := true;
												writeln('Player 2 ran out of HP.');
												writeln('-PLAYER 1 VICTORY-');
											end
											else
											begin
												case enemyattack[i] of
													4 :	begin
															writeln('Player 2 recovered  1 HP.');
															enemyHP += 1;
														end;
													5 :	begin
															writeln('Player 2 dealt 1 damage to Player 1.');
															allyHP -= 1;
														end;
													6 :	begin
															writeln('Player 2 recovered 2 HP.');
															enemyHP += 2;
														end;
													7 :	begin
															writeln('Player 2 dealt 2 damage to Player 1.');
															allyHP -= 2;
														end;
												end;
											end;
										end;
								end;
								readln;
							end;
						end;
						if (allyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := false;
							writeln('Player 1 ran out of HP.');
							writeln('-PLAYER 2 VICTORY-');
						end
						else if (enemyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := true;
							writeln('Player 2 ran out of HP.');
							writeln('-PLAYER 1 VICTORY-');
						end;
					until battlefinish;
					readln;
					clrscr;
					if result then
					begin
						writeln('Congratulations to Player 1 for the Victory.');
					end
					else
					begin
						writeln('Congratulations to Player 2 for the Victory.');
					end;
					readln;
				end;
			3:	begin
					clrscr;
					writeln('-TUTORIAL-');
					writeln('-Win Condition-');
					writeln('Your objective in this game is to beat your opponent in a one-on-one battle.');
					writeln('You can accomplish that by using a variety of moves to reduce the health points (HP) of your opponent to 0 or lower.');
					readln;
					writeln('-Phases and Turns-');
					writeln('The Battle is broken down into 2 phases and 3 turns each round.');
					writeln('In the first phase, the Selection Phase, you select the Moves that are going to be used each turn.');
					writeln('If you are playing Arcade Mode, you can see the Moves that the enemy is going to use in 1-3 of the 3 turns according to the difficulty you have chosen.');
					writeln('In the second phase, the Execution Phase, you will see the 3 turns unfold with the Moves you have chosen.');
					readln;
					writeln('-Moves-');
					writeln('There are 2 kinds of Moves you can use in the game, Normal and Item.');
					writeln('Normal Moves are free to use and there are 3 types of it, Quick Attack, Charging Attack, and Blocking Attack.');
					writeln('Quick Attack inflict 1 damage to an enemy using Charging Attack, Charging Attack inflict 1 damage to an enemy using Blocking Attack, and Blocking Attack Inflict 1 damage to an enemy using Quick Attack.');
					writeln('Same type Normal Moves will cancel each other.');
					writeln('Item Moves uses the effect of an item you have in your inventory in exchange for the item itself.');
					writeln('Item Moves also negate the effect of Normal Moves so use them wisely!');
					writeln('In addition, enemy skills that are not Normal Moves are also considered Item Moves.'); 
					writeln('Now, try battling for yourself!');
					readln;
					
					clrscr;
					writeln('-BATTLE-');
					writeln('-Player vs Slime-');
					battlefinish := false;
					inventory[1] := 5;
					inventory[2] := 5;
					inventory[3] := 5;
					inventory[4] := 5;
					round := 0;
					allyHP := 100;
					enemyHP := 3;
					writeln('Your HP : ', allyHP);
					writeln('Enemy HP : ', enemyHP);
					writeln('Press Enter to start the battle.');
					readln;
					repeat
						writeln('Your HP : ', allyHP);
						writeln('Enemy HP : ', enemyHP);
						round += 1;
						writeln('-Round ', round, '-');
						writeln('-Selection Phase-');
						readln;
						for i:= 1 to 3 do
						begin
							randomize;
							enemyattack[i] := random(3) + 1;
							case enemyattack[i] of
								1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
								2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
								3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
							end;
						end;
						
						for i := 1 to 3 do
						begin
							
							writeln('-Turn ', i, '-');
							writeln('Select your Move:');
							writeln('1. Quick Attack');
							writeln('2. Charging Attack');
							writeln('3. Blocking Attack');
							if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
							begin
								writeln('4. Item');
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
							end
							else
							begin
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									wrongOptionSelected(wrongoption, option, 3);
								until trueoption(option, 3);
							end;
							if option <=3 then 
							begin
								allyattack[i] := option;
							end
							else
							begin
								writeln('Select an Item:');
								writeln('1. Healing Potion 	Held : ', inventory[1]);
								writeln('2. Poison Arrow	Held : ', inventory[2]);
								writeln('3. Large Healing Potion	Held : ', inventory[3]);
								writeln('4. Poison Bullet	Held : ', inventory[4]);
								repeat
									wrongoption := false;
									write('Your Choice : '); readln(option);
									if (inventory[option] <= 0) and (option>0) and (option<5)  then
									begin
										option += 4;
										writeln('You cannot use something you do not hold.');
									end;
									wrongOptionSelected(wrongoption, option, 4);
								until trueoption(option, 4);
								inventory[option] -= 1;
								allyattack[i] := option + 3;
							end;
						end;
						
						writeln('-Execution Phase-');
						readln;
						for i:= 1 to 3 do
						begin
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('You ran out of HP.');
								writeln('-DEFEAT-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('The enemy ran out of HP.');
								writeln('-VICTORY-');
							end
							else
							begin
								case allyattack[i] of
									1 :	begin
											case enemyattack[i] of
												1 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												2 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												3 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									2 :	begin
											case enemyattack[i] of
												2 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												3 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												1 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									3 :	begin
											case enemyattack[i] of
												3 : begin
														writeln('Nothing Happened on Turn ', i,'.');
													end;
												1 :	begin
														writeln('You dealt 1 damage to the enemy.');
														enemyHP -= 1;
													end;
												2 : begin
														writeln('You were dealt 1 damage by the enemy.');
														allyHP -= 1;
													end;
											end;
										end;
									4 :	begin
											writeln('You recovered 1 HP.');
											allyHP += 1;
										end;
									5 :	begin
											writeln('You dealt 1 damage to the enemy.');
											enemyHP -= 1;
										end;
									6 :	begin
											writeln('You recovered 2 HP.');
											allyHP += 2;
										end;
									7 :	begin
											writeln('You dealt 2 damage to the enemy.');
											enemyHP -= 2;
										end;
								end;
								readln;
							end;
						end;
						if (allyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := false;
							writeln('You ran out of HP.');
							writeln('-DEFEAT-');
						end
						else if (enemyHP <= 0) and not(battlefinish) then
						begin
							battlefinish := true;
							result := true;
							writeln('The enemy ran out of HP.');
							writeln('-VICTORY-');
						end;
					until battlefinish;
					readln;
					
					clrscr;
					if result then 
					begin
						writeln('Easy, right? There was no way for you to lose that battle.');
					end
					else
					begin
						writeln('Huh? You lost? Well... You must be uhh... dedicated? Whatever the case, this is truly shocking.');
						writeln('For someone like you, I have a special prize, Hidden Ending No. 5! Enjoy...');
						endingunlock[5] := true;
					end;	
					writeln('Whenever you feel like you need more basic training, please do come here again.');
					readln;
				end;
			4:	begin
					clrscr;
					for i:= 1 to 4 do
					begin
						if endingunlock[i] then
						begin
							writeln(i, '. Unlocked');
						end
						else
						begin
							writeln(i, '. Locked');
						end;
					end;
					if endingunlock[5] then
					begin
						writeln('5. Unlocked');
					end;
					readln;
				end;
			5:	begin
					AreYouSure(sure, wrongyesno, yesno);
					if sure then
					begin
						quit := true;
					end;
				end;
			6:	begin
					if not(endingunlock[3]) then 
					begin
						writeln('Wrong option selected, please re-enter your choice.');
					end
					else
					begin
						clrscr;
						writeln('Welcome to the Extra Hell!');
						writeln('Now you will face the Extra Boss!');
						writeln('Enjoy...');
						readln;
						
						clrscr;
						writeln('-EXTRA HELL-');
						writeln('-Player vs Mistress of Ruin-');
						clrscr;
						allyHP := 10;
						battlefinish := false;
						round := 0;
						enemyHP := 20;
						inventory[1] := 2;
						inventory[2] := 2;
						inventory[3] := 1;
						inventory[4] := 1;
						writeln('Your HP : ', allyHP);
						writeln('Enemy HP : ', enemyHP);
						writeln('Press Enter to start the battle.');
						readln;
						repeat
							randomize;
							writeln('Your HP : ', allyHP);
							writeln('Enemy HP : ', enemyHP);
							round += 1;
							writeln('-Round ', round, '-');
							writeln('-Selection Phase-');
							readln;
							
						
							countshown := random(2) + 1;
							
							randomize;
							case countshown of 
								1:	begin
										moveshown[1] := false;
										moveshown[2] := false;
										moveshown[3] := false;
										moveshown[random(3)+1] := true;
									end;
								2:	begin
										moveshown[1] := true;
										moveshown[2] := true;
										moveshown[3] := true;
										moveshown[random(3)+1] := false;
									end;
								3:	begin
										moveshown[1] := true;
										moveshown[2] := true;
										moveshown[3] := true;
									end;
							end;
							randomize;
							for i:= 1 to 3 do
							begin
								if random < 0.66 then
								begin
									enemyattack[i] := random(3) + 1;
								end
								else
								begin
									enemyattack[i] := random(2) + 4;
								end;
								if moveshown[i] then
								begin
									case enemyattack[i] of
										1 : writeln('Turn ', i, ' : The enemy is preparing a Quick Attack.');
										2 : writeln('Turn ', i, ' : The enemy is preparing a Charging Attack.');
										3 : writeln('Turn ', i, ' : The enemy is preparing a Blocking Attack.');
										4 : writeln('Turn ', i, ' : The enemy is preparing Ruin itself.');
										5 : writeln('Turn ', i, ' : The enemy is preparing a Divine Healing Magic.');
									end;
								end
								else
								begin
									writeln('Turn ', i, ' : ???');
								end;
							end;
							
							for i := 1 to 3 do
							begin
								
								writeln('-Turn ', i, '-');
								writeln('Select your Move:');
								writeln('1. Quick Attack');
								writeln('2. Charging Attack');
								writeln('3. Blocking Attack');
								if (inventory[1] > 0) or (inventory[2] > 0) or (inventory[3] > 0) or (inventory[4] > 0) then
								begin
									writeln('4. Item');
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 4);
									until trueoption(option, 4);
								end
								else
								begin
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										wrongOptionSelected(wrongoption, option, 3);
									until trueoption(option, 3);
								end;
								if option <=3 then 
								begin
									allyattack[i] := option;
								end
								else
								begin
									writeln('Select an Item:');
									writeln('1. Healing Potion 	Held : ', inventory[1]);
									writeln('2. Poison Arrow	Held : ', inventory[2]);
									writeln('3. Large Healing Potion	Held : ', inventory[3]);
									writeln('4. Poison Bullet	Held : ', inventory[4]);
									repeat
										wrongoption := false;
										write('Your Choice : '); readln(option);
										if (inventory[option] <= 0) and (option>0) and (option<5)  then
										begin
											option += 4;
											writeln('You cannot use something you do not hold.');
										end;
										wrongOptionSelected(wrongoption, option, 4);
									until trueoption(option, 4);
									inventory[option] -= 1;
									allyattack[i] := option + 3;
								end;
							end;
							
							writeln('-Execution Phase-');
							readln;
							for i:= 1 to 3 do
							begin
								if (allyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := false;
									writeln('You ran out of HP.');
									writeln('-DEFEAT-');
								end
								else if (enemyHP <= 0) and not(battlefinish) then
								begin
									battlefinish := true;
									result := true;
									writeln('The enemy ran out of HP.');
									writeln('-VICTORY-');
								end
								else
								begin
									case allyattack[i] of
										1 :	begin
												case enemyattack[i] of
													1 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													2 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													3 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
														end;
													5 : begin
															writeln('The enemy recovered 2 HP');
															enemyHP += 2;
														end;
												end;
											end;
										2 :	begin
												case enemyattack[i] of
													2 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													3 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													1 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
														end;
													5 : begin
															writeln('The enemy recovered 2 HP');
															enemyHP += 2;
														end;
												end;
											end;
										3 :	begin
												case enemyattack[i] of
													3 : begin
															writeln('Nothing Happened on Turn ', i,'.');
														end;
													1 :	begin
															writeln('You dealt 1 damage to the enemy.');
															enemyHP -= 1;
														end;
													2 : begin
															writeln('You were dealt 1 damage by the enemy.');
															allyHP -= 1;
														end;
													4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
														end;
													5 : begin
															writeln('The enemy recovered 2 HP');
															enemyHP += 2;
														end;
												end;
											end;
										4 :	begin
												writeln('You recovered 1 HP.');
												allyHP += 1;
												case enemyattack[i] of
													4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
														end;
													5 : begin
															writeln('The enemy recovered 2 HP');
															enemyHP += 2;
														end;
												end;
											end;
										5 :	begin
												writeln('You dealt 1 damage to the enemy.');
												enemyHP -= 1;
												if (enemyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := true;
													writeln('The enemy ran out of HP.');
													writeln('-VICTORY-');
												end
												else
												begin
													case enemyattack[i] of
														4 :	begin
																writeln('You were dealt 3 damage by the enemy.');
																allyHP -= 3;
															end;
														5 : begin
																writeln('The enemy recovered 2 HP');
																enemyHP += 2;
															end;
													end;
												end;
											end;
										6 :	begin
												writeln('You recovered 2 HP.');
												allyHP += 2;
												case enemyattack[i] of
													4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
														end;
													5 : begin
															writeln('The enemy recovered 2 HP');
															enemyHP += 2;
														end;
												end;
											end;
										7 :	begin
												writeln('You dealt 2 damage to the enemy.');
												enemyHP -= 2;
												if (enemyHP <= 0) and not(battlefinish) then
												begin
													battlefinish := true;
													result := true;
													writeln('The enemy ran out of HP.');
													writeln('-VICTORY-');
												end
												else
												begin
													case enemyattack[i] of
														4 :	begin
															writeln('You were dealt 3 damage by the enemy.');
															allyHP -= 3;
															end;
														5 : begin
																writeln('The enemy recovered 2 HP');
																enemyHP += 2;
															end;
													end;
												end;
											end;
									end;
									readln;
								end;
							end;
							if (allyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := false;
								writeln('You ran out of HP.');
								writeln('-DEFEAT-');
							end
							else if (enemyHP <= 0) and not(battlefinish) then
							begin
								battlefinish := true;
								result := true;
								writeln('The enemy ran out of HP.');
								writeln('-VICTORY-');
							end;
						until battlefinish;
						readln;
						if result then
						begin
							clrscr;
							writeln('So you completed the Extra Stage yes ?');
							writeln('Well after completing Hell, I was sure you will come here sooner or later and it looks like I was correct.');
							writeln('What should you do after this? Well... There is the Vs. Mode and the Hidden Ending no. 5 left.');
							writeln('Where is ending no. 5 you ask?');
							writeln('Look somewhere you least expect and you might find it.');
							writeln('That is all, Thank you for playing RPSB!');
							endingunlock[4] := true;
							readln;
						end
						else
						begin
							clrscr;
							writeln('-GAME OVER-');
							writeln('Better luck next time.');
						end;
						
					end;
				end;		
			else begin
				writeln('Wrong option selected, please re-enter your choice.');
				end;
		end;
	until (quit = true);
	rewrite(endingfile);
	for i:= 1 to 5 do
	begin
		write(endingfile, endingunlock[i]);
	end;
end.