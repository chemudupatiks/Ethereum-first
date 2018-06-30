pragma solidity ^0.4.20;

mapping (string => address) quoteRegistry;

contract myContract{

  function () {
    msg.sender.send(msg.value);
  }

	function registerQuote (string _quote) {
    quoteRegistry[_quote] = msg.sender;
	}

	function ownership (string _quote) returns (address) {
    return quoteRegistry[_quote];
	}

	function transfer(string _quote, address _newOwner) payable {
    if(msg.value >= 500000000000000000){
      quoteRegistry[_quote]= _newOwner;
    }else if(msg.value > 0){
      msg.sender.send(msg.value);
    }
	}
	function owner () returns (address){
    return address(this);
	}
}
