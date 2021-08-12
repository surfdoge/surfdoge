 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.7;

interface SurfDoge {
   function WreckPaperHands() external;
   function PumpItUp() external;
   function canWePumpIt() external pure returns (bool) ;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 public _lockTime;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
     constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() private view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    
    //Added function
    // 1 minute = 60
    // 1h 3600
    // 24h 86400
    // 1w 604800

    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    function unlock() public virtual {
        require(_previousOwner == msg.sender);
        require(block.timestamp > _lockTime , "Not time yet");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
    
}


contract HelperContract is Ownable {

    event SurfDogePumped();
    event PaperHandsWrecked();
    event SurplusTransferError ();
	
	address surfDogeAddress = 0x98B8509Bc35ECa982b07e19283D40B8E2A1d6A7D;

    SurfDoge public surfdoge;
    
    constructor () {
        surfdoge = SurfDoge(surfDogeAddress);
    }

    function emptySurplusOfBNB () public onlyOwner {
        uint256 surplus = address(this).balance - 10000000000000000; //0,01 BNB stays
        (bool successfulSurplusTransfer, )  = payable(surfDogeAddress).call {value: surplus}("");
         if (!successfulSurplusTransfer) { emit SurplusTransferError (); }
    }
    

    receive() external payable {
        
        surfdoge.WreckPaperHands();
		emit PaperHandsWrecked();
		
        if (surfdoge.canWePumpIt()) {
            emit SurfDogePumped();
    		surfdoge.PumpItUp();
        }
    }   
}