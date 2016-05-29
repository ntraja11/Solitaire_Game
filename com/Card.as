package com {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.Global;
	import flash.events.Event;
	
	public class Card extends MovieClip{
		public var cardType:String;
		public var cardColor:String;
		public var cardIndex:Number;
		public var droptarget:Object = new Object();
		public var dropTargetObject:MovieClip;
		public var arrayMc:MovieClip;
		public var cardMc:MovieClip;
		public var storeMc:MovieClip;
		public var tempMc:MovieClip;
		public var stored:Boolean = false;
		public var moveCardGroup:Boolean = false;

		public function Card() {			
		}
		
		public function setCard(){			
			this.symbolMc.gotoAndStop(cardType);
			this.symbolIcon.gotoAndStop(cardType);
			this.buttonMode = true;
			this.doubleClickEnabled = true;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);
			this.addEventListener(MouseEvent.DOUBLE_CLICK, checkToStore);
		}
		
		public function checkToStore(dcm:MouseEvent):void{			
			Global.currCard = Object(dcm.currentTarget);
			Global.currCardID = Global.currCard.cardIndex;			
			stored = false;
			if(MovieClip(Global.currCard.parent).getChildIndex(MovieClip(Global.currCard)) == MovieClip(Global.currCard.parent).numChildren-1){
				for(var s:Number = 1; s <= 4; s++){
					storeMc = Global.parentMc["store_" + s];
					if(!storeMc.currCardValue && Global.currCardID == 1){					
						droptarget = storeMc;					
						dropMe();						
						stored = true;
						s = 5;
					}
					else if(storeMc.currCardValue == Global.currCardID-1 && storeMc.currCardColor == Global.currCard.cardColor && storeMc.currCardType == Global.currCard.cardType){					
						droptarget = storeMc;					
						dropMe();						
						stored = true;
						s = 5;
					}
				}				
			}			
			
			if(!stored && MovieClip(Global.currCard.parent).getChildIndex(MovieClip(Global.currCard)) == MovieClip(Global.currCard.parent).numChildren-1){
				
				for(var p:Number = 1; p <= 4; p++){
					tempMc = Global.parentMc["temp_" + p];
					if(tempMc.empty){					
						droptarget = tempMc;					
						dropMe();						
						p = 5;
					}					
				}				
				
			}
		}
		
		function checkTempStatus(xPos:Number){
			for(var t:Number = 1; t <= 4; t++){
				tempMc = Global.parentMc["temp_" + t];
				if(tempMc.x == xPos){
					tempMc.empty = true;					
				}
			}
		}
		
		public function dragMe(dr:MouseEvent):void{
			droptarget = null;
			if(MovieClip(this.parent).getChildIndex(this) == MovieClip(this.parent).numChildren-1 && MovieClip(this.parent).name.split("_")[0] == "array"){				
				arrayMc = MovieClip(this.parent);
				Global.currCard = Object(dr.currentTarget);
				Global.currCardID = Global.currCard.cardIndex;
				Global.cardInitX = Global.currCard.x;
				Global.cardInitY = Global.currCard.y;
				
				setIndex(arrayMc, this);
				setIndex(MovieClip(Global.parentMc), arrayMc);
				this.startDrag(false, Global.stageArea);
				
				this.addEventListener(MouseEvent.MOUSE_UP, dropMe);						
			}
			else if(MovieClip(this.parent).name.split("_")[0] == "root1"){	
				
				Global.currCard = Object(dr.currentTarget);
				Global.currCardID = Global.currCard.cardIndex;
				Global.cardInitX = Global.currCard.x;
				Global.cardInitY = Global.currCard.y;
				checkTempStatus(Global.cardInitX);
				setIndex(MovieClip(Global.parentMc), this);
				this.startDrag(false, Global.stageArea);
				this.addEventListener(MouseEvent.MOUSE_UP, dropMe);						
			}
			else{				
				arrayMc = MovieClip(this.parent);
				Global.currCard = null;				
				Global.index1 = arrayMc.getChildIndex(this);
				Global.index2 = arrayMc.numChildren;				
				checkCardGroup();				
			}
		}
		
		public function dropMe(dp:MouseEvent=null):void{				
			if(droptarget == null){
				this.stopDrag();
				droptarget = MovieClip(Object(dp.currentTarget).dropTarget.parent);
			}	
						
			if(droptarget.name.split("_")[0] == "temp"){				
				Global.currCard.x = droptarget.x;
				Global.currCard.y = droptarget.y;										
				Global.parentMc.addChild(Global.currCard.parent.removeChild(this));					
				droptarget.empty = false;				
			}
			else if(droptarget.name.split("_")[0] == "store" && MovieClip(droptarget).currCardValue == Global.currCardID-1 && (MovieClip(Global.currCard).cardColor == MovieClip(droptarget).currCardColor || MovieClip(droptarget).currCardColor == null) && (MovieClip(Global.currCard).cardType == MovieClip(droptarget).currCardType || MovieClip(droptarget).currCardType == null) ){								
				Global.currCard.x = droptarget.x;
				Global.currCard.y = droptarget.y;										
				Global.parentMc.addChild(Global.currCard.parent.removeChild(this));	
				MovieClip(droptarget).currCardValue = Global.currCardID;
				if(MovieClip(droptarget).currCardColor == null){
					MovieClip(droptarget).currCardColor = MovieClip(Global.currCard).cardColor;
					MovieClip(droptarget).currCardType = MovieClip(Global.currCard).cardType;
				}				
				if(Global.currCardID == 13){
					Global.completeCount++;
					checkGameComplete();
				}
				Global.parentMc.setChildIndex(Global.currCard, Global.parentMc.getChildIndex(droptarget));
				MovieClip(Global.currCard).removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);
			}
			else if(droptarget.name.split("_")[0] == "card"){
				dropTargetObject = MovieClip(droptarget);
				if(dropTargetObject.cardColor != Global.currCard.cardColor && dropTargetObject.cardIndex-1 == Global.currCard.cardIndex && MovieClip(dropTargetObject.parent).numChildren-1 == MovieClip(dropTargetObject.parent).getChildIndex(dropTargetObject)){					
					Global.currCard.x = dropTargetObject.x;
					Global.currCard.y = dropTargetObject.y + Global.parentMc.vGap;								
					MovieClip(dropTargetObject.parent).addChild(Global.currCard.parent.removeChild(this));				
				}else{
					resetCard();
				}				
			}
			else if(droptarget.name.split("_")[0] == "symbolMc"){
				dropTargetObject = MovieClip(droptarget.parent);
				if(dropTargetObject.cardColor != Global.currCard.cardColor && dropTargetObject.cardIndex-1 == Global.currCard.cardIndex && MovieClip(dropTargetObject.parent).numChildren-1 == MovieClip(dropTargetObject.parent).getChildIndex(dropTargetObject)){
					Global.currCard.x = dropTargetObject.x;
					Global.currCard.y = dropTargetObject.y + Global.parentMc.vGap;										
					MovieClip(dropTargetObject.parent).addChild(Global.currCard.parent.removeChild(this));
				}else{
					resetCard();
				}				
			}
			else if(droptarget.name == "bg"){	
				Global.currCard.x = droptarget.x;
				Global.currCard.y = droptarget.y;	
				MovieClip(droptarget.parent).addChild(Global.currCard.parent.removeChild(this));				
			}
			else{				
				resetCard();
			}	
			MovieClip(Global.currCard).removeEventListener(MouseEvent.MOUSE_UP, dropMe);
		}
				
		public function checkCardGroup(){
			for(var i:Number = Global.index1; i < Global.index2-1; i++){
				cardMc = MovieClip(arrayMc.getChildAt(i));						
				if(cardMc.cardIndex == MovieClip(arrayMc.getChildAt(i+1)).cardIndex+1 && cardMc.cardType != MovieClip(arrayMc.getChildAt(i+1)).cardType){
					moveCardGroup = true;
				}
				else{					
					moveCardGroup = false;
					i = Global.index2;
				}	
			}
			if(MovieClip(arrayMc.getChildAt(Global.index2-1)).cardIndex == cardMc.cardIndex-1 && cardMc.cardType != MovieClip(arrayMc.getChildAt(Global.index2-1)).cardType){
				moveCardGroup = true;
			}		
			
			if(moveCardGroup){
				cardMc = MovieClip(arrayMc.getChildAt(Global.index1));
				Global.currCard = cardMc;
				Global.cardInitX = cardMc.x;
				Global.cardInitY = cardMc.y;
				Global.currCardID = cardMc.cardIndex;
				
				setIndex(MovieClip(Global.parentMc), arrayMc);
				cardMc.startDrag(false, Global.stageArea);		
				cardMc.addEventListener(MouseEvent.MOUSE_MOVE, dragCardGroup);
			}
		}		
		
		public function dragCardGroup(mt:MouseEvent):void{
			for(var j:Number = Global.index1+1; j < Global.index2; j++){
				var cards:MovieClip = MovieClip(arrayMc.getChildAt(j));
				cards.x = MovieClip(Global.currCard).x;
				cards.y = MovieClip(Global.currCard).y + (Global.parentMc.vGap * (arrayMc.getChildIndex(cards)-arrayMc.getChildIndex(cardMc)));				
			}
			
			cardMc.addEventListener(MouseEvent.MOUSE_UP, dropCardGroup);			
			moveCardGroup = false;
		}
		
		public function dropCardGroup(dcg:MouseEvent):void{
			cardMc.stopDrag();
			droptarget = MovieClip(Object(dcg.currentTarget).dropTarget.parent);
			cardMc.removeEventListener(MouseEvent.MOUSE_MOVE, dragCardGroup);
			
			if(droptarget.name.split("_")[0] == "card"){				
				dropTargetObject = MovieClip(droptarget);				
				if(dropTargetObject.cardColor != Global.currCard.cardColor && dropTargetObject.cardIndex-1 == Global.currCard.cardIndex && MovieClip(dropTargetObject.parent).numChildren-1 == MovieClip(dropTargetObject.parent).getChildIndex(dropTargetObject)){					
					Global.currCard.x = dropTargetObject.x;
					Global.currCard.y = dropTargetObject.y + Global.parentMc.vGap;							
					MovieClip(dropTargetObject.parent).addChild(arrayMc.removeChild(MovieClip(Global.currCard)));	
					shiftCardGroup();										
				}else{					
					resetCardGroup();
				}				
			}
			else if(droptarget.name.split("_")[0] == "symbolMc"){				
				dropTargetObject = MovieClip(droptarget.parent);								
				if(dropTargetObject.cardColor != Global.currCard.cardColor && dropTargetObject.cardIndex-1 == Global.currCard.cardIndex && MovieClip(dropTargetObject.parent).numChildren-1 == MovieClip(dropTargetObject.parent).getChildIndex(dropTargetObject)){					
					Global.currCard.x = dropTargetObject.x;
					Global.currCard.y = dropTargetObject.y + Global.parentMc.vGap;							
					MovieClip(dropTargetObject.parent).addChild(arrayMc.removeChild(MovieClip(Global.currCard)));	
					shiftCardGroup();										
				}else{					
					resetCardGroup();
				}				
			}
			else if(droptarget.name == "bg"){	
				dropTargetObject = MovieClip(droptarget);	
				Global.currCard.x = dropTargetObject.x;
				Global.currCard.y = dropTargetObject.y;	
				MovieClip(dropTargetObject.parent).addChild(Global.currCard.parent.removeChild(this));		
				shiftCardGroup();
			}
			else{
				resetCardGroup();
			}
		}
		
		public function setIndex(parentClip:MovieClip, childClip:MovieClip){
			parentClip.setChildIndex(childClip, parentClip.numChildren-1);
		}

		public function resetCard(){
			Global.currCard.x = Global.cardInitX;
			Global.currCard.y = Global.cardInitY;
		}
		
		public function resetCardGroup(){
			Global.currCard.x = Global.cardInitX;
			Global.currCard.y = Global.cardInitY;
			for(var j:Number = arrayMc.getChildIndex(MovieClip(Global.currCard))+1; j < arrayMc.numChildren; j++){
				var cards:MovieClip = MovieClip(arrayMc.getChildAt(j));
				cards.x = MovieClip(Global.currCard).x;
				cards.y = MovieClip(Global.currCard).y + (Global.parentMc.vGap * (arrayMc.getChildIndex(cards)-arrayMc.getChildIndex(cardMc)));				
			}
		}	
		
		public function shiftCardGroup(){						
			for(var j:Number = Global.index1; j <= arrayMc.numChildren-1;){
				var cards:MovieClip = MovieClip(arrayMc.getChildAt(j));						
				cards.x = MovieClip(Global.currCard).x;				
				cards.y = MovieClip(Global.currCard).y + Global.parentMc.vGap * (MovieClip(dropTargetObject.parent).numChildren - MovieClip(dropTargetObject.parent).getChildIndex(MovieClip(Global.currCard)) );								
				MovieClip(dropTargetObject.parent).addChild(arrayMc.removeChild(cards))
			}						
		}
		
		public function checkGameComplete(){
			if(Global.completeCount == 4){
				Global.parentMc.resultMc.visible = true;
			}
		}
		

	}	
}
