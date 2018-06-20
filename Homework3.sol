pragma solidity ^0.4.20;

contract myContract{
	struct Quoter{
		address addressOfQuoter;
		string [] quotes;
	}
	mapping (address => Quoter) storage quoteRegistry;
	function registerQuote (string _quote) public {
		quoteRegistry[Quoter({
			
	}
	function ownership (string _quote) returns (address) {
	}
	function transfer(string _quote, address _newOwner) payable {
	}
	function owner () returns (address){
	}
}