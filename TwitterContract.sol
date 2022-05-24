// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

contract tweets{

   address public owner;
   uint256 private counter;  //Unique iddentifier for each tweet

   constructor(){
        counter =0; 
        owner = msg.sender;  //address of owner of smart contract
   }

   //can b invoked whenever we use a function for tweet
   struct tweet {
       address tweeter;
       uint256 id ;
       string tweetText;
       string tweetImg;
   }

    //can be invoked to send message to blockchain that new tweet were created
    event tweetCreated (
       address tweeter,
       uint256 id ,
       string tweetText,
       string tweetImg
    );

   mapping(uint256 => tweet) tweetMap;

   //function to add a tweets
   function addTweet(
    string memory tweetText,
    string memory tweetImg
   )
   public payable {
   require(msg.value == (1 ether), "Please submit 1 Matic");

   tweet storage obj = tweetMap[counter];
   obj.tweetText = tweetText;
   obj.tweetImg = tweetImg;
   obj.tweeter = msg.sender; //address of sender whoever will be calling addTweet
   obj.id = counter ;

   //emit the tweetcreated event so that it can be viwed in blockexploreler.
   emit tweetCreated(
                msg.sender, 
                counter, 
                tweetText, 
                tweetImg
            );
            counter++;

            //make sure funds are transfer to the contract owner
            payable(owner).transfer(msg.value);
   }
   
   //getTweet func helps to go through logs of what was tweeted with id
   function getTweet(uint256 id) public view returns (
       string memory,
       string memory,
       address 
   ){
       require(id < counter, "No such Tweet");
       tweet storage t  = tweetMap[id];
       return(t.tweetText,t.tweetImg,t.tweeter); //will return who made that tweet with content of that tweet
   }

}