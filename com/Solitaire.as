package com{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import com.Global;
	import com.RandomArray;
	import flash.events.MouseEvent;
 	
	
	public class Solitaire extends MovieClip{
		
		var cardMc:MovieClip;
		var xPos:Number = 0;
		var yPos:Number = 0;
		var hGap:Number = 20;
		var vGap:Number = 25;		
		var rCount:Number = 1;
		var cardValue:String;
		var cType:Number;
		var tempMc:MovieClip;
		var storeMc:MovieClip;
		var arrayMc:MovieClip;
		var arrayCount:Number = 1;
		var rArray:RandomArray;
		var totalCardsArray:Array = new Array();
				
		var typeArray:Array = new Array("Spade", "Flower", "Heart", "Diamond");		
		var colorArray:Array = new Array("Black", "Red");
		var cardArray:Array = new Array("K", "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q");

		public function Solitaire() {
			Global.parentMc = MovieClip(this);						
		}
		
		public function startGame(){
			Global.currCard = null;
			xPos = 0;
			yPos = 0;			
			rCount = 1;
			arrayCount = 1;
			
			resultMc.visible = false;
			setTempStoreProperties();
			createCards();			
			
			newGameMc.buttonMode = true;
			newGameMc.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		private function restartGame(rt:MouseEvent):void{
			
			Global.parentMc.gotoAndPlay("startGame");
			//startGame();
		}
		
		private function createCards(){			
			rArray = new RandomArray(52);
			totalCardsArray = rArray.randomArray
 			//trace(" Elements in the Random Array :" + totalCardsArray);
			
			for(var i:int = 1; i <= 52; i++){
				cardMc = new Card();
				cardMc.mouseChildren = false;
				cardMc.name = "card_" + totalCardsArray[(i-1)];		
								
				if(arrayCount	> 7){
					 arrayCount = 1;
					 rCount++;					
				}
				
				arrayMc = this["array_" + arrayCount];					
				cardMc.y = arrayMc.bg.y + (rCount-1) * vGap;						
				
				cardValue = cardArray[(totalCardsArray[(i-1)] % 13)];				
				cardMc.cardIdTop.text = cardValue;
				cardMc.cardIdBottom.text = cardValue;
				
				cType = Math.floor(totalCardsArray[(i-1)] / 13);
				(cType > 0 && totalCardsArray[(i-1)]%13 == 0) ? cType-- : "";
				cardMc.cardType = typeArray[cType];	
				
				cardMc.cardColor = (cType < 2) ? colorArray[0] : colorArray[1];
				cardMc.cardIndex = (totalCardsArray[(i-1)]%13 != 0) ? totalCardsArray[(i-1)]%13 : 13;
				cardMc.setCard();
								
				cardMc.x = arrayMc.bg.x;
				arrayMc.addChild(cardMc);				
				arrayCount++;
				
			}
			
			Global.stageArea = new Rectangle(0, 0, this.stage.width-cardMc.width, this.stage.height-cardMc.height);			
		}
		
		private function setTempStoreProperties(){
			for(var t:Number = 1; t <= 4; t++){
				tempMc = this["temp_" + t];
				tempMc.empty = true;
				storeMc = this["store_" + t];
				storeMc.currCardValue = 0;
				storeMc.currCardColor = null;
				storeMc.currCardType = null;
				storeMc.empty = true;				
			}
		}

	}
	
}
