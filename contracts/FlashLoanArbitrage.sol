// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IDex} from "./interfaces/IDex.sol";

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;

    IERC20 private dai;
    IERC20 private usdc;
    IDex private dexContract;

    constructor(
        address _addressProvider,
        address _dexContractAddress,
        address _daiAddress,
        address _usdcAddress
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);

        dai = IERC20(_daiAddress);
        usdc = IERC20(_usdcAddress);
        dexContract = IDex(_dexContractAddress);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Ensure this contract initiated the flash loan
        require(initiator == address(this), "Unauthorized flash loan initiator");
        
        // Store initial balance
        uint256 initialBalance = IERC20(asset).balanceOf(address(this));
        require(initialBalance >= amount, "Flash loan not received");
        
        // Arbitrage operation - use actual flash loan amount, not hardcoded value
        if (asset == address(usdc)) {
            // Approve USDC for DEX
            usdc.approve(address(dexContract), amount);
            
            // Execute arbitrage
            dexContract.depositUSDC(amount);
            dexContract.buyDAI();
            dexContract.depositDAI(dai.balanceOf(address(this)));
            dexContract.sellDAI();
            
            // Check profitability
            uint256 finalBalance = usdc.balanceOf(address(this));
            uint256 amountOwed = amount + premium;
            require(finalBalance >= amountOwed, "Arbitrage not profitable");
        }

        // Approve the Pool contract allowance to "pull" the owed amount
        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);

        return true;
    }

    function requestFlashLoan(address _token, uint256 _amount) public onlyOwner {
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            address(this), // receiverAddress
            _token, // asset
            _amount,
            params,
            referralCode
        );
    }

    function approveUSDC(uint256 _amount) external returns (bool) {
        return usdc.approve(address(dexContract), _amount);
    }

    function allowanceUSDC() external view returns (uint256) {
        return usdc.allowance(address(this), address(dexContract));
    }

    function approveDAI(uint256 _amount) external returns (bool) {
        return dai.approve(address(dexContract), _amount);
    }

    function allowanceDAI() external view returns (uint256) {
        return dai.allowance(address(this), address(dexContract));
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
}
