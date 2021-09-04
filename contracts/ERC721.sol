// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./IERC721.sol";
import "./Strings.sol";
import "./Ownable.sol";

contract ERC721 is IERC721, Ownable { 
    
    using Strings for uint256;
    
    string private _name;
    string private _symbol;
    string internal baseURI_;
    
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _owners;
    
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
 
    
    
    // ************************************************** // 
    
    constructor () {
        _name = "TheNFTToken";
        _symbol = "TNT";
    }
    
   
   
    // ************************************************** // 
    
    modifier isExists(uint256 tokenID){
        require(_owners[tokenID] != address(0),"ERC721: tokenID does not exists");
        _;
    }
    
    modifier isAuthorizer(address owner_, address operator,uint256 tokenID){
        
        require(
            owner_ == _owners[tokenID] ||
            operator == _tokenApprovals[tokenID] ||
            isApprovedForAll(owner_, operator),"ERC721: caller is not a valid authorizer" );
        _;
    }
    
    
    // ************************************************** //
     
    function tokenURI(uint256 tokenID)external view returns(string memory){
      return  _tokenURI(tokenID) ;
    } 
    
    
   function _tokenURI(uint256 tokenID)internal isExists(tokenID) view returns(string memory){
        string memory baseURI  = baseURI_;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenID.toString())) : "";
    } 
     
    
    // ************************************************** // 
    
    function name()public view returns(string memory){
        return _name;
    }
    
    function symbol()public view returns(string memory){
        return _symbol;
    }
    
    function contractBalance()public view returns(uint256){
        return address(this).balance;
    }
    
    
    
    
    // ************************************************** // 
    
    function balanceOf(address owner) external view virtual override returns(uint256){
        require(owner != address(0),"ERC721: checking balance for zero address");
        return _balances[owner];
    }
    
    function ownerOf(uint256 tokenID) external view isExists(tokenID) virtual override returns(address){
        address owner = _owners[tokenID];
        require(owner != address(0),"ERC721: checking tokenID for zero address");
        return owner; 
    }
    
    
    
     // ************************************************** // 
     
    function approve(address operator, uint256 tokenID) external
        isExists(tokenID)
        isAuthorizer(msg.sender, operator, tokenID) virtual override {
            _approve(operator, tokenID);
    }
    
    function _approve(address operator, uint256 tokenID) internal virtual {
       _tokenApprovals[tokenID] = operator;
       emit Approval(_owners[tokenID], operator, tokenID);
    }
    
    function getApproved(uint256 tokenID) external view
        isExists(tokenID)
        override returns(address operator) {
            return _tokenApprovals[tokenID];
    }
    
    
    
    // ************************************************** // 
    
    function setApprovalForAll(address operator, bool approved) external override {
        require(msg.sender != operator, "ERC721: caller to apporver");
        
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll (msg.sender, operator, approved);
    }
    
    function isApprovedForAll(address owner, address operator)public view override returns(bool){
        return _operatorApprovals[owner][operator];
    }
    
    function unsetApprovalForAll(address operator, bool unApproved) external {
        require(msg.sender != operator, "ERC721: caller to apporver");
        
        _operatorApprovals[msg.sender][operator] = unApproved;
        emit ApprovalForAll (msg.sender, operator, unApproved);
    }
    
    
    
     // ************************************************** // 
    
     function transferFrom(
        address from,
        address to,
        uint256 tokenID
        )external override isAuthorizer (from, msg.sender, tokenID) {
           
           _transferFrom(from, to, tokenID); 
        }
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenID
        )external override isAuthorizer (from, msg.sender, tokenID) {
           
           safeTransferFrom(from, to, tokenID,""); 
        }
    
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenID,
        bytes memory data
        )public override isAuthorizer (from, msg.sender, tokenID) {
          
           _transferFrom(from, to, tokenID); 
        }
    
    function _transferFrom(
        address from,
        address to,
        uint256 tokenID
        )internal virtual
        isAuthorizer (from, msg.sender, tokenID) 
        isExists(tokenID) {
           
           require(to != address(0),"receipient is not a valid address");
           _approve(address(0),tokenID);
           
           _balances[from] -= 1;
           _balances[to] += 1;
           
           _owners[tokenID] = to;
           emit Transfer(from, to, tokenID);
        }
        
        
        
        
    // ************************************************** //     
        
     function _mint(address to, uint256 tokenID) internal virtual {
         
        require(to != address(0), "ERC721: mint to the zero address");
        require(!(_owners[tokenID] != address(0)), "ERC721: token already minted");

            _balances[to] += 1;
            _owners[tokenID] = to;

        emit Transfer(address(0), to, tokenID);
        }
        
        
        
}