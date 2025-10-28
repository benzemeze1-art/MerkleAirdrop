// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library M { function h(bytes32 a, bytes32 b) internal pure returns (bytes32){return a<b? keccak256(abi.encodePacked(a,b)) : keccak256(abi.encodePacked(b,a));}}
contract MerkleAirdrop {
    using M for bytes32;
    bytes32 public root; mapping(address=>bool) public claimed; event Claimed(address a, uint256 amt);
    constructor(bytes32 _root){root=_root;}
    function verify(bytes32 leaf, bytes32[] memory proof) public view returns(bool ok){
        bytes32 hash=leaf; for(uint i=0;i<proof.length;i++){ hash = hash.h(proof[i]); } ok = (hash==root);
    }
    function claim(uint256 amount, bytes32[] calldata proof) external {
        require(!claimed[msg.sender],"claimed");
        require(verify(keccak256(abi.encodePacked(msg.sender,amount)), proof),"bad proof");
        claimed[msg.sender]=true; emit Claimed(msg.sender, amount);
        // Token transfer burada yapılır.
    }
}
