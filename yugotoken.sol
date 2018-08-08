pragma solidity ^0.4.24;

/*
--------------------------------------------------------------------------------
The YUGO [YUG] Token Smart Contract

Credit:
Radivoje Peskic radivoje.peskic@gmail.com 
YugoNova 

ERC20: https://github.com/ethereum/EIPs/issues/20

MIT Licence
--------------------------------------------------------------------------------
*/

import "./SafeMath.sol";

contract YugoToken {
    using SafeMath for uint256;

    /* Contract Constants */
    string public constant _name = "Yugo Token";
    string public constant _symbol = "YUG";
    uint8 public constant _decimals = 12;

    /* The supply is initially 1,000,000,000 YUG to the precision of 12 decimals */
    uint256 public constant _initialSupply = 1000000000000000000000;

    /* Contract Variables */
    address public owner;
    uint256 public _currentSupply;
    mapping(address => uint256) public balances;
    mapping(address => mapping (address => uint256)) public allowed;

    /* Constructor initializes the owner's balance and the supply  */
    function YugoToken() {
        owner = msg.sender;
        _currentSupply = _initialSupply;
        balances[owner] = _initialSupply;
    }

    /* ERC20 Events */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from, address indexed to, uint256 value);

    /* ERC20 Functions */
    /* Return current supply in smallest denomination (1YUG = 1000000000) */
    function totalSupply() constant returns (uint256 totalSupply) {
        return _initialSupply;
    }

    /* Returns the balance of a particular account */
    function balanceOf(address _address) constant returns (uint256 balance) {
        return balances[_address];
    }
    
    /* Transfer the balance from the sender's address to the address _to */
    function transfer(address _to, uint256 _value) public returns (bool) {
      require(_value <= balances[msg.sender]);
      require(_to != address(0));

      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      emit Transfer(msg.sender, _to, _value);
      return true;
    }
    
    /* Allows _spender to withdraw the _value amount form sender */
    function approve(address _spender, uint256 _value) public returns (bool) {
      allowed[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
    }
    
    /* Withdraws to address _to form the address _from up to the amount _value */
    function transferFrom(
      address _from,
      address _to,
      uint256 _value
    )
      public
      returns (bool)
    {
      require(_value <= balances[_from]);
      require(_value <= allowed[_from][msg.sender]);
      require(_to != address(0));

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
      emit Transfer(_from, _to, _value);
      return true;
    }
    
    /* Checks how much _spender can withdraw from _owner */
    function allowance(
      address _owner,
      address _spender
     )
      public
      view
      returns (uint256)
    {
      return allowed[_owner][_spender];
    }
}
