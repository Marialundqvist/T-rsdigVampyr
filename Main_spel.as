package 
{ 
			import flash.display.MovieClip;
			import flash.events.KeyboardEvent;
			import flash.ui.Keyboard;
			import flash.events.Event;
			import flash.text.TextField;
			import flash.events.MouseEvent;
			import flash.net.FileReference;
			
			
			public class Main_spel extends MovieClip {
				//Declare variables. vilka funktioner spelet ska ha
				var startsida:Startsida;
				var spelsida:Spelsida;
				var instruktionssida:Instruktionssida;
				var vx:int;
				var vy:int;
				var velocity:uint;
				var score:uint;
				var collision:Boolean;
				var replayButton:ReplayButton;
				var mySoundK:Knappljud = new Knappljud();
				var mySoundV:Vitlokljud = new Vitlokljud();
				var mySoundB:Blodljud = new Blodljud();
				var count:uint;
				
				var startatSpel = false;
				
				
				//Skapar array för flera vitlökar
				var vitlokArray = new Array();
				
				
				var vitlokVel:int = 0;
				var droppeVel:int = 0;
				var droppe1Vel:int = 0;
				var droppe2Vel:int = 0;
				
				
				
				
				
				//-------------------
				//Constructor
				public function Main_spel() {
					init(); 
				}
				
				
				//-------------------
				//Inilializes game
				private function init():void {
					
					
					spelsida = new Spelsida();
					startsida = new Startsida();
					instruktionssida = new Instruktionssida();
					
					
					//knappar
					startsida.startgame.addEventListener(MouseEvent.CLICK, onStartGameClick);
					startsida.instruktioner.addEventListener(MouseEvent.CLICK, onInstruktionerClick);
					instruktionssida.tillbaka.addEventListener(MouseEvent.CLICK, onTillbakaClick);
					addChild(startsida);
					
					//Stoppar animation
					spelsida.vitlok.stop();
					spelsida.dracula.stop();
					spelsida.droppe.stop();
					spelsida.droppe1.stop();
					
					
					//Startar variabler
					vx = 0;
					vy = 0;
					//dracula hastighet
					velocity = 25;
					score = 0;
					collision = false;
					replayButton = new ReplayButton ();
				
					//Sätter score texten
					spelsida.scoreDisplay.text = String(score);
				
					//Plasering för replayButton (START)
					replayButton.x = 750;
					replayButton.y = 230;
				
					//Startar om health meter
					spelsida.health.meter.scaleX = 1;
					
									
					//replayButton knapp till scen 
					stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownPress);
					stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUpPress);
					stage.addEventListener(Event.ENTER_FRAME, onEnterFrameEvent);
				
					//Sätter focus till scenen (behövs efter omstart)
					stage.focus = stage;
				}
				
				
				//---------
				//Hanterar när spelet är slut (endgame)
				private function endGame():void {
					
					//Lägger till replayButton till scen 
					stage.addChild(replayButton);
					
					//replayButton knapp
					replayButton.addEventListener (MouseEvent.CLICK, onReplayButtonClick);
					
					//Removes event listeners for game play
					stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownPress);
					stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUpPress);
					stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameEvent);  
				}
				
				//-------------
				//Hanterar replay button knappklick
				private function onReplayButtonClick(e:MouseEvent) {
					
					
					//Ta bort replay listener
					replayButton.removeEventListener(MouseEvent.CLICK, onReplayButtonClick);
					//knappljud
					mySoundK.play();
					
					//Ta bort replay button
					stage.removeChild(replayButton);
					
					
					//Starta om spelet
					init ();
					
				}
				
									
				//------------------- 
				//Hanterar ner tryckta piltandgenterna
				function onKeyDownPress(e:KeyboardEvent):void {
								//Checks which button was pressed
								if (e.keyCode == Keyboard.LEFT) {
												vx = -velocity;//Moves dracula left
								} else if (e.keyCode == Keyboard.RIGHT) {
												vx = velocity; //Moves dracula right
								
								} 
				} 
				
				//------------------- 
				//Hanterar när man släpper tandgenterna
				function onKeyUpPress(e:KeyboardEvent):void {
								//Resets variables values depending on key pressed (to stop dracula)
								if (e.keyCode == Keyboard.LEFT || e.keyCode == Keyboard.RIGHT) {
														vx = 0;
								} else if (e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.UP) {
														vy = 0;
								}
				} 
				
				//-------------------
				//Hanter det som ligger på scenen
				private function onEnterFrameEvent(e:Event):void {
									//Bestämmer droppe och vitlök position						
									if(count%70==0){						
									var vitlok =  new Vitlok ();
									var droppe =  new Droppe ();
									var droppe1 = new Droppe1 ();
									var droppe2 = new Droppe2 ();
									var vitlokstartX = Math.floor(Math.random()*800) +10;
									var droppestartX = Math.floor(Math.random()*800) +10;
									var droppe1startX = Math.floor(Math.random()*800) +10;
									var droppe2startX = Math.floor(Math.random()*800) +10;
									spelsida.vitlok.y = 0;
									spelsida.vitlok.x = vitlokstartX;
									spelsida.droppe.y = 0;
									spelsida.droppe.x = droppestartX;
									spelsida.droppe1.y = 0;
									spelsida.droppe1.x = droppe1startX;
									spelsida.droppe2.y = 0;
									spelsida.droppe2.x = droppe2startX;
										
									//Placerar ut flera vitlökar (de skapades i klickfunktionen för start game)
									for(var p:int=0; p<8; p++){
											vitlokArray.push(new Vitlok ());
											vitlokArray[p].x = Math.floor(Math.random()*800) +10;
											vitlokArray[p].y = 0;
											
											
									}
								
										
									}
									
									
									
									//Flyttar flera vitlökar
									
									if(startatSpel)
									{
										
									for(var i:int=0; i<8; i++){
											vitlokArray[i].y+=12;
											
									}
									
									spelsida.droppe.y+=10+droppeVel;
									spelsida.vitlok.y+=10+vitlokVel;
									spelsida.droppe1.y+=10+droppe1Vel;
									spelsida.droppe2.y+=10+droppe2Vel;
									count++;
									
										//Flytta droppar och vitlökar hastighet
									droppeVel+=0.9;
									vitlokVel+=0.9;
									droppe1Vel+=0.7;
									droppe2Vel+=0.9;
									
									}
									
									
								//Fytta dracula (i.e. uppdaterar draculas position)
								spelsida.dracula.x += vx;
								spelsida.dracula.y += vy;
								
							
								//Draculas plasering
								var draculaHalfWidth:uint = spelsida.dracula.width / 2;
								var draculaHalfHeight:uint = spelsida.dracula.height / 6;
								
								//Stoppa dracula vis scenens slut
								if ((spelsida.dracula.x + draculaHalfWidth) > stage.stageWidth) { 
										spelsida.dracula.x = stage.stageWidth - draculaHalfWidth;
								} else if (spelsida.dracula.x - draculaHalfWidth < 0) {
										spelsida.dracula.x = 0 + draculaHalfWidth ;

								}

								if (spelsida.dracula.y - draculaHalfHeight < 0) {
										spelsida.dracula.y = 0 + draculaHalfHeight;
								} else if (spelsida.dracula.y  + draculaHalfHeight > stage.stageHeight) {
										spelsida.dracula.y = stage.stageHeight - draculaHalfHeight;
								}
								
								
//----------------------------------------------KROCK MED DROPPE-------------------------
				
								//Krock.  dracula med droppe
								if (spelsida.dracula.hitTestObject(spelsida.droppe)) {
									spelsida.messageDisplay.text = "Slurp!";
									mySoundB.play();
									
								
									
									
									
									//Höjer hälsomätaren health meter
									if (spelsida.health.meter.scaleX <= 1) {
										spelsida.health.meter.scaleX += 0;
									}
									
									
									//lägger till poäng, score
									if (!collision) {
										score++;
										spelsida.scoreDisplay.text = String(score);
										collision = true;
										
									}
									
									
									
								//dracula ändrar inte utsende när han krockar
									spelsida.dracula.gotoAndStop (1);
								} else {
									
											
									//Drucula har sitt vanliga utseende när han inte krockar
									spelsida.dracula.gotoAndStop (1);
									spelsida.droppe.gotoAndStop (1);
									spelsida.droppe1.gotoAndStop (1);
									spelsida.droppe2.gotoAndStop (1);
									
									collision = false;
								}
								
								
								
		//----------------------------------------------KROCK MED DROPPE1-------------------------
				
								//Krock.  dracula med droppe
								if (spelsida.dracula.hitTestObject(spelsida.droppe1)) {
									spelsida.messageDisplay.text = "Slurp!";
									mySoundB.play();
									
								
									
									
									
									//Höjer hälsomätaren health meter
									if (spelsida.health.meter.scaleX <= 1) {
										spelsida.health.meter.scaleX += 0;
									}
									
									
									//lägger till poäng, score
									if (!collision) {
										score++;
										spelsida.scoreDisplay.text = String(score);
										collision = true;
										
									}
									
									
									
								//dracula ändrar inte utsende när han krockar
									spelsida.dracula.gotoAndStop (1);
								} else {
									
											
									//Drucula har sitt vanliga utseende när han inte krockar
									spelsida.dracula.gotoAndStop (1);
									spelsida.droppe.gotoAndStop (1);
									spelsida.droppe1.gotoAndStop (1);
									spelsida.droppe2.gotoAndStop (1);
									collision = false;
								}
								
								
								
		//----------------------------------------------KROCK MED DROPPE2-------------------------
				
								//Krock.  dracula med droppe
								if (spelsida.dracula.hitTestObject(spelsida.droppe2)) {
									spelsida.messageDisplay.text = "Slurp!";
									mySoundB.play();
									
								
									
									
									
									//Höjer hälsomätaren health meter
									if (spelsida.health.meter.scaleX <= 1) {
										spelsida.health.meter.scaleX += 0;
									}
									
									
									//lägger till poäng, score
									if (!collision) {
										score++;
										spelsida.scoreDisplay.text = String(score);
										collision = true;
										
									}
									
									
									
								//dracula ändrar inte utsende när han krockar
									spelsida.dracula.gotoAndStop (1);
								} else {
									
											
									//Drucula har sitt vanliga utseende när han inte krockar
									spelsida.dracula.gotoAndStop (1);
									spelsida.droppe.gotoAndStop (1);
									spelsida.droppe1.gotoAndStop (1);
									spelsida.droppe2.gotoAndStop (1);
									
									collision = false;
								}
								
			//-----------------------------------VITLÖK KROCK------------------------------------
								
								//Dracula krockar med vitlök. text kommer upp, ljud spelas upp
								if (spelsida.dracula.hitTestObject(spelsida.vitlok)) {
									spelsida.messageDisplay.text = "Aj!";
									mySoundV.play();
									
									
									
									
									
									//Hälsomätaren minskar health meter 
									if (spelsida.health.meter.scaleX > 0) {
										spelsida.health.meter.scaleX -= 0.05;
										
										
									}
									
									
									
									
									//Dracua ändrar utseende när han krockar med vitlök
									spelsida.dracula.gotoAndStop (2);
								} else {
									
											
									//När dracula inte krockar med vitlök har han sitt vanliga utseende
									spelsida.dracula.gotoAndStop (1);
									spelsida.vitlok.gotoAndStop (1);
									
									collision = false;
									
									
								}
								
//--------------------------VITLÖK KROCK (FLER VITLÖKAR)----------------------------		
				
			//Dracula krockar med vitlök. text kommer upp, ljud spelas upp
								for(var z:int=0; z<vitlokArray.length; z++)
								{
									if (spelsida.dracula.hitTestObject(vitlokArray[z])) {
											spelsida.messageDisplay.text ="Aj!";
											mySoundV.play();
											
											
										
										//Hälsomätare minskar health meter
										if (spelsida.health.meter.scaleX > 0) {
												spelsida.health.meter.scaleX -= 0.05;
										}
										
										//Dracula ändrar utseende när han krockar med vitlök
										spelsida.dracula.gotoAndStop (2);
										
										
								} else {
									
										//När dracula inte krockar med vitlök har han sitt vanliga utseende
										spelsida.dracula.gotoAndStop (1);
										vitlokArray[z].gotoAndStop (1);
									
										collision = false;
								
								
									
								}
		}//end loop					
								
										
								//När spelet ska sluta game over
								if (spelsida.health.meter.width < 1) {
									spelsida.messageDisplay.text = "Game Over!";
									endGame();
									
									
									var file:FileReference = new FileReference();									
									file.save("You scored: " +score, "highscore.txt")
									
								}	
								
								

								
								}
								
			//Funktion för startgameknapp
			private function onStartGameClick(e:MouseEvent):void{
				startatSpel = true;
				addChild(spelsida);
				addChild(spelsida.vitlok);						  
				addChild(spelsida.droppe);
				addChild(spelsida.droppe1);
				addChild(spelsida.droppe2);
				
				//skapar vitlökar
				for(var i:int=0; i<8; i++){
					
							vitlokArray.push(new Vitlok());
							vitlokArray[i].x = Math.floor(Math.random()*800) +10;
							vitlokArray[i].y = 0;
					
							addChild(vitlokArray[i]);
							
					
						}
						
				removeChild(startsida);
				mySoundK.play();		
			}
			
			
     		//Funktion för instruktionsknapp
				private function onInstruktionerClick(e:MouseEvent):void{
					addChild(instruktionssida);
					removeChild(startsida);
					mySoundK.play();
	
									
			}
			
			
     		//Funktion för tillbakaknapp
				private function onTillbakaClick(e:MouseEvent):void{
					addChild(startsida);
					removeChild(instruktionssida);
					mySoundK.play();
				
				
		}
			
	}
}