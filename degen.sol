// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20,Ownable,ERC20Burnable{

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){}

    //redeemable items
    enum Cards{rare,superRare,epic,mythic,legendary}

    struct Player{
        address toAddress;
        uint amount;
    }
    //to create the queue of player for buying degen 
    Player[] public players;

    struct PlayerCards{
        uint rare;
        uint superRare;
        uint epic;
        uint mythic;
        uint legendary;        
    }

    //To store the redeemed cards
    mapping (address=>PlayerCards) public playerCards;

    function buyDegen(address _toAddress,uint _amount)public{
        players.push(Player({toAddress:_toAddress,amount:_amount}));
    }

    //mint tokens for the buyers in the queue
    function mintToken() public onlyOwner {
        //loop to mint tokens for buyers in queue
        while (players.length!=0) {
            uint i = players.length -1;
            if (players[i].toAddress != address(0)) { // Check for non-zero address
            _mint(players[i].toAddress, players[i].amount);
            players.pop();
            }
        }
    }
    
    //Transfert tokens to other player
    function transferDegen(address _to, uint _amount)public {
        require(_amount<=balanceOf(msg.sender),"low degen");
        _transfer(msg.sender, _to, _amount);
    }

    //Redeem different cards
    function redeemCards( Cards _card)public{
        if(_card == Cards.rare){
            require(balanceOf(msg.sender)>=10,"Low degen");
            playerCards[msg.sender].rare +=1;
            burn(10);
        }else if(_card == Cards.superRare){
            require(balanceOf(msg.sender)>=20,"Low degen");
            playerCards[msg.sender].superRare +=1;
            burn(20);
        }else if(_card == Cards.epic){
            require(balanceOf(msg.sender)>=30,"Low degen");
            playerCards[msg.sender].epic +=1;
            burn(30);
        }else if(_card == Cards.mythic){
            require(balanceOf(msg.sender)>=40,"Low degen");
            playerCards[msg.sender].mythic +=1;
            burn(40);
        }else if(_card == Cards.legendary){
            require(balanceOf(msg.sender)>=50,"Low degen");
            playerCards[msg.sender].legendary +=1;
            burn(50);
        }else{
            revert("invalid card selected");
        }
    }

    //function to burn token
    function burnDegen(address _of, uint amount)public {
        _burn(_of, amount);
    }

    //function to check the tokens
    function checkBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }
}
//0x1234567890abcdef1234567890abcdef12345678
