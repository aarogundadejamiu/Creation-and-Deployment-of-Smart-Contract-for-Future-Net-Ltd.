// SPDX-License-Identifier: MIT

// Solidity version to be used for compiling the contract set between version 0.8.0 and 0.9.0
pragma solidity >=0.8.0 <0.9.0;

/**
 * @title TokenContract
 * @dev The development of simple smart contract for Future Net Ltd.
 */

 // Define the smart contract name
contract TokenContract {

    // Declare public variable to stores the name of the token
    string public constant name = "TokenContract";
    string public constant symbol = "FTK";
    uint8 public constant decimals = 18;

    // Token supply and balances
    uint256 public totalSupply;
    mapping(address => uint256) public tokenBalances;
    mapping(address => mapping(address => uint256)) public allowances;
    address public owner;


    // Transaction history
    struct Transaction {
        address from;
        address to;
        uint256 amount;
    }
    Transaction[] public transactions;

    // Events 'notificatioon' for token transfers and approvals
    event TokenTransfer(address indexed from, address indexed to, uint256 amount);
    event TokenApproval(address indexed owner, address indexed spender, uint256 amount);

    /**
     * @dev Modifier to check if the caller is the owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "You don't have the permission to make this change");
        _;
    }

    /**
     * @dev Constructor that initializes the contract with an initial token supply.
     * @param _initialSupply The initial token supply to be minted.
     */
    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * (10**uint256(decimals));
        tokenBalances[msg.sender] = totalSupply;
        emit TokenTransfer(address(0), msg.sender, totalSupply);
    }


    /**
     * @dev Transfers tokens from the caller's account to the specified address.
     * @param _to The address to transfer tokens to.
     * @param _amount The amount of tokens to transfer.
     * @return bool Success indicator.
     */
    function transfer(address _to, uint256 _amount) public onlyOwner returns (bool) {
        require(_to != address(0), "Invalid recipient address");
        require(_amount <= tokenBalances[msg.sender], "Insufficient balance");

        tokenBalances[msg.sender] -= _amount;
        tokenBalances[_to] += _amount;

        transactions.push(Transaction(msg.sender, _to, _amount));
        emit TokenTransfer(msg.sender, _to, _amount);
        return true;
    }


    /**
     * @dev Mints new tokens and assigns them to the caller's account.
     * @param _amount The amount of tokens to mint.
     */
    function mintTokens(uint256 _amount) public onlyOwner {
        uint256 amountWithDecimals = _amount * (10**uint256(decimals));
        totalSupply += amountWithDecimals;
        tokenBalances[msg.sender] += amountWithDecimals;
        emit TokenTransfer(address(0), msg.sender, amountWithDecimals);
    }


    /**
     * @dev Approves another address to spend the specified amount of tokens on behalf of the caller.
     * @param _spender The address to approve for spending.
     * @param _amount The amount of tokens to approve for spending.
     * @return bool Success indicator.
     */
    function approve(address _spender, uint256 _amount) public onlyOwner returns (bool) {
        allowances[msg.sender][_spender] = _amount;
        emit TokenApproval(msg.sender, _spender, _amount);
        return true;
    }

}