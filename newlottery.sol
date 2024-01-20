// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address payable owner;
    constructor()
    {
        owner=payable(msg.sender);
    }
    address[] participants;
    mapping(address=>uint) Isparticipant;

    address winner;
    mapping(address=>uint) countWinning;
    mapping(address=>uint) balance;
    bool lotteryCompleted;
    // For participants to enter the pool
     function enter() public payable {
        require(msg.value==(0.1 ether + countWinning[msg.sender] * 0.01 ether));
        require(owner!=msg.sender);
        require(Isparticipant[msg.sender]== 0);
        for(uint i = 0; i<participants.length; i++){
            require(participants[i] !=msg.sender); //doubt
        }
        uint entryFee;
        uint index;
        entryFee = msg.value/10;
        owner.transfer(entryFee);
        balance[owner]+=entryFee;
        Isparticipant[msg.sender]=1;
        balance[msg.sender]= msg.value-entryFee;
        participants.push(msg.sender);
        if(participants.length == 5){
            index=uint(keccak256(abi.encodePacked(block.timestamp,participants.length))) % participants.length;
            winner=participants[index];
            Isparticipant[winner]=0;
            countWinning[winner]++;
            payable(winner).transfer(address(this).balance);
            participants=new address[](0);
            lotteryCompleted=true;
        }

     }

    // For participants to withdraw from the pool
    function withdraw() public {
        bool flag;
        for(uint i=0; i < participants.length; i++){
        if(participants[i]==msg.sender)
        flag=true;
    }
    require(participants.length<5);
    payable(msg.sender).transfer(balance[msg.sender]);
    balance[msg.sender]=0;
    Isparticipant[msg.sender]=0;
    //Players.pop();
    for(uint i=0; i<participants.length; i++){   //doubt
    if(participants[i]==msg.sender){
        for(uint j=i; j<participants.length-1; j++){
            participants[j]=participants[j+1];
        }
        participants.pop();
    }
   
    }
    }

// To view participants in current pool
function viewParticipants() public view returns (address[] memory,uint256){
        return (participants,participants.length);
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        require(lotteryCompleted==true);
        return winner;
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint256) {
        require(msg.sender==owner);
        return balance[owner];
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint256) {
        return address(this).balance;
    }
    }



