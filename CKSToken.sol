pragma solidity ^0.4.20;

contract CKSToken{

  address owner;
  bool halfSold = false;

  struct Member{
    uint balance;
    mapping (address => uint) allowedSpenders;
    address[] arrayOfAllowedSpenders;
  }
  mapping (address => Member) addressToOwners;
//each unit of token represents 100 units inside the contract. This means this contract has 1000 tokens.

  function() payable{
    if(!halfSold){
      uint tokensDemanded = (msg.value/(0.1 ether))*20;
      if(addressToOwners[owner].balance - tokensDemanded < 50000){
        sendAtHalfPrice(msg.sender, 50000);
        sendAtFullPrice(msg.sender, tokensDemanded-50000);
      }
      else{
      sendAtHalfPrice(msg.sender, tokensDemanded);
      }
    } else{
      uint tokens = (msg.value/(0.1 ether))*10;
      if(addressToOwners[owner].balance - tokens < 0){
          sendAtFullPrice(msg.sender, addressToOwners[owner].balance);
          msg.sender.transfer((tokens-addressToOwners[owner].balance)/100 ether);
      }
      else{
        sendAtFullPrice(msg.sender, tokens);
      }
    }
  }

  function sendAtHalfPrice(address _to, uint tokens) internal {
    addressToOwners[owner].balance-= tokens;
    addressToOwners[msg.sender].balance+= tokens;
    Transfer(owner, msg.sender, tokens);
  }

  function sendAtFullPrice(address _to, uint tokens) internal{
    addressToOwners[owner].balance-= tokens;
    addressToOwners[msg.sender].balance+= tokens;
    Transfer(owner, msg.sender, tokens);
  }

  function CKSToken() public{
    owner = msg.sender;
    addressToOwners[msg.sender].balance = totalSupply();
  }
  function name() public pure returns (string){
    return "CKrishnaSai";
  }
  function symbol() pure public returns (string){
    return "CKS";
  }
  function decimals() pure public returns(uint8){
    return uint8(2);
  }
  function totalSupply() public pure returns (uint){
    return uint(100000);
  }
  function balanceOf(address tokenOwner) public constant returns (uint balance){
    return addressToOwners[tokenOwner].balance;
  }
  function allowance(address tokenOwner, address spender) public constant returns (uint remaining){
    return addressToOwners[tokenOwner].allowedSpenders[spender];
  }
  function transfer(address to, uint tokens) public returns (bool success){
    require(to != address(0));
    require(addressToOwners[msg.sender].balance >= tokens);
    addressToOwners[msg.sender].balance-= tokens;
    addressToOwners[to].balance+= tokens;
    Transfer(msg.sender, to, tokens);
    return true;
  }

  function approve(address spender, uint tokens) public returns (bool success){
    require(tokens<=addressToOwners[msg.sender].balance);
    addressToOwners[msg.sender].allowedSpenders[spender]= tokens;
    addressToOwners[msg.sender].arrayOfAllowedSpenders.push(spender);
    Approval(msg.sender, spender, tokens);
    addressToOwners[msg.sender].balance -= tokens;
    return true;
  }

  function transferFrom(address from, address to, uint tokens) public returns (bool success){
    require(checkForApproval(from, msg.sender));
    require(addressToOwners[from].allowedSpenders[msg.sender] >= tokens);
    addressToOwners[from].balance-= tokens;
    addressToOwners[to].balance+= tokens;
    Transfer(from, to, tokens);
    return true;
  }

  function checkForApproval(address from, address _spender) public view returns (bool success){
    bool present = false;
    for(uint i =0; i< addressToOwners[from].arrayOfAllowedSpenders.length; i++){
      if(addressToOwners[from].arrayOfAllowedSpenders[i]== _spender){
        present = true;
      }
    }
    return present;
  }
  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}
