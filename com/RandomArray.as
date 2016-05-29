package com{
// This is a class to create an array of random numbers for the given limit.\
// To use this - open a new file in AS3, import RandomArray, then instantiate this class with a whole number as a parameter
// or use the following code:
/* 	import RandomArray;
 	var rArray:RandomArray = new RandomArray(10);
 	trace(" Elements in the Random Array :" + rArray.randomArray);
	
 	You can see the numbers 1 to 10 arranged randomly in the array 
*/


class RandomArray
{
	 var randomArray:Array;					// Variable Declaration
	 var valueArray:Array;
	 var randomNumber:Number;
	 var lenth:Number;
	 var totalLength:Number;
	 var pushIntoArray:Boolean;

	function RandomArray(limitGiven:Number)
	{
		randomArray = new Array();					// Initiating variables
		valueArray = new Array();
		lenth = 0;
		pushIntoArray = false;
		totalLength = limitGiven;
		createArray();
		//trace("            ------ Calling Random Array Class -----");
	}
	
	function createArray()					// Function to create an array of random numbers for the given length.
	{
		for(var count:Number = 0; count < totalLength; count++)
		{		
			lenth = randomArray.length;	
			randomNumber = Math.ceil(Math.random() * totalLength);
			
			if(lenth == 0)
			{
				pushIntoArray = true;
			}
			
			else
			{		
				for(var i:Number = 0; i < lenth; i++)
				{
					if(randomArray[i] != randomNumber)
					{
						pushIntoArray = true;						
					}
					else 
					{
						pushIntoArray = false;
						i = lenth;					
					}
					
				}
			}
			
			if(pushIntoArray && lenth < totalLength)
			{
				randomArray.push(randomNumber);					
				pushIntoArray = false;			
			}
			else
			{			
				count--;
			}		
		}		
	}	
}


}