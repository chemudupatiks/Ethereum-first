pragma solidity ^0.4.20;

import "./AbstractMultiSig.sol"
contract MultiSigWallet is AbstractMultiSig{

/*!!!!! Variables !!!!!!!!!!!!*/
bool storage isActive = false;
mapping (uint => address) propsalsSubmitted;
mapping (address => uint) amountPerProposal;
mapping (uint => bool) openStatus;
mapping (address => uint) noOfSigners;
mapping (address => uint) contributors;
address [] arrayOfContributors;
uint noOfOpenProposals =0;
uint totalContribution = 0;

function () payable {
  contributors[msg.sender] = msg.value;
  arrayOfContributors.push(msg.sender);
  ReceivedContribution(msg.sender, msg.value)
  totalContribution+= msg.value;
}
/*
 * This function should return the onwer of this contract or whoever you
 * want to receive the Gyaan Tokens reward if it's coded correctly.
 */
function owner() external returns(address){
  return address(this);
}

/*
 * This event should be dispatched whenever the contract receives
 * any contribution.
 */
event ReceivedContribution(address indexed _contributor, uint _valueInWei);

/*
 * When this contract is initially created, it's in the state
 * "Accepting contributions". No proposals can be sent, no withdraw
 * and no vote can be made while in this state. After this function
 * is called, the contract state changes to "Active" in which it will
 * not accept contributions anymore and will accept all other functions
 * (submit proposal, vote, withdraw)
 */
function endContributionPeriod() external{
   isActive = true;
}

/*
 * Sends a withdraw proposal to the contract. The beneficiary would
 * be "_beneficiary" and if approved, this address will be able to
 * withdraw "value" Ethers.
 *
 * This contract should be able to handle many proposals at once.
 */
 uint storage id = 0;
function submitProposal(uint _valueInWei) external{
  require(isActive == true);
  require(_valueInWei <= 0.1*totalContribution);
  id++;
  ProposalSubmitted(msg.sender, _valueInWei);
  propsalsSubmitted[id] = msg.sender;
  amountPerProposal[msg.sender] = _valueInWei;
  openStatus[id] = true;
  noOfOpenProposals++;
  noOfSigners[msg.sender] =0;
}
event ProposalSubmitted(address indexed _beneficiary, uint _valueInWei);

/*
 * Returns a list of beneficiaries for the open proposals. Open
 * proposal is the one in which the majority of voters have not
 * voted yet.
 */
function listOpenBeneficiariesProposals() external view returns (address[]){
  address [] listOpenProposals = new uint[](noOfOpenProposals);
  uint counter = 0;
  for(uint i = 0; i< propsalsSubmitted.length; i++){
    if(openStatus[i] == true){
      listOpenProposals[counter] = propsalsSubmitted[i];
      counter++;
    }
  }
  return listOpenProposals;
}

/*
 * Returns the value requested by the given beneficiary in his proposal.
 */
function getBeneficiaryProposal(address _beneficiary) external view returns (uint){
  return amountPerProposal[_beneficiary];
}

/*
 * List the addresses of the contributors, which are people that sent
 * Ether to this contract.
 */
function listContributors() external view returns (address[]){
  return arrayOfContributors;
}

/*
 * Returns the amount sent by the given contributor in Wei.
 */
function getContributorAmount(address _contributor) external view returns (uint){
  return contributors[_contributor];
}

/*
 * Approve the proposal for the given beneficiary
 */
 modifier isSigner {
  require(msg.sender == 0xfa3c6a1d480a14c546f12cdbb6d1bacbf02a1610 || msg.sender == 0x2f47343208d8db38a64f49d7384ce70367fc98c0 || msg.sender == 0x7c0e7b2418141f492653c6bf9ced144c338ba740);
  _;
 }
function approve(address _beneficiary) external isSigner {
  noOfSigners[_benefiaciary]++;
  ProposalApproved(msg.sender, _beneficiary, amountPerProposal[_beneficiary]);
  if(noOfSigners[_beneficiary]>1){
    openStatus[]
  }
}
event ProposalApproved(address indexed _approver, address indexed _beneficiary, uint _valueInWei);

/*
 * Reject the proposal of the given beneficiary
 */
function reject(address _beneficiary) external isSigner{
  ProposalRejected(msg.sender, _beneficiary, amountPerProposal[_beneficiary]);
}
event ProposalRejected(address indexed _approver, address indexed _beneficiary, uint _valueInWei);

/*
 * Withdraw the specified value in Wei from the wallet.
 * The beneficiary can withdraw any value less than or equal the value
 * he/she proposed. If he/she wants to withdraw more, a new proposal
 * should be sent.
 *
 */
function withdraw(uint _valueInWei) external;
event WithdrawPerformed(address indexed _beneficiary, uint _valueInWei);

}
