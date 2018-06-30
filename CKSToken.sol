pragma solidity ^0.4.20;

contract CKSToken{
  struct Member{
    uint balance;
    mapping (address => uint) allowedSpenders;
    address[] arrayOfAllowedSpenders;
  }
  mapping (address => Member) addressToOwners;

  function CKSToken() public{
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
