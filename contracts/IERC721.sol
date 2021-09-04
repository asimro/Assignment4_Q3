// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface IERC721 {

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenID);
    event Approval(address indexed owner, address indexed operator, uint256 indexed tokenID);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
 
 
 
    function balanceOf(address owner)external view returns(uint256 balance);
    function ownerOf(uint256 tokenID)external view returns(address owner);
    
    
    
    function approve(address operator,uint256 tokenID)external;
    function getApproved(uint256 tokenID)external view returns(address operator);
    
    
    
    function setApprovalForAll(address operator,bool approved) external;
    function isApprovedForAll(address owner,address operator)external view returns(bool);

    
    
    
    function transferFrom(
        address from,
        address to,
        uint256 tokenID
        )external;
        
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenID
        ) external;
        
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenID,
        bytes calldata data
        ) external;

}