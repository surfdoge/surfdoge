 // SPDX-License-Identifier: MIT
 
pragma solidity 0.8.7;

contract BNBDistributionSurfDoge {

    event MarketingTransferError();
    event TeamTransferError(uint256 indexed walletNumber);
    
    address marketing = 0x77D8D444b87F8C5989bBF17c02f51ADfC4399669; // Marketing
    address team1 = 0x2E431fc0397131Aaa23b85159C4759DB75aEa4f7; // Team 1
    address team2 = 0x7E442cD54E44Eddd263E985bF53eeb4401062144; // Team 2
    address team3 = 0xef77Aa0e5B8b9F4F07d07432aB68dbFEEC9F6FFE; // Team 3
    
    uint256 public marketingDistributed;
    uint256 public teamDistributed;

    receive() external payable {
        
        uint256 newBalance = address(this).balance;
        marketingDistributed += (newBalance / 2);
        teamDistributed += (newBalance / 2);

        (bool successfulMarketingTransfer, ) =  payable(marketing).call {value: newBalance/2}("");
        if (!successfulMarketingTransfer) { emit MarketingTransferError(); }
        
        (bool successfulTeamTransfer1, ) = payable(team1).call {value: newBalance/6}("");
         if (!successfulTeamTransfer1) { emit TeamTransferError(1); }
         
        (bool successfulTeamTransfer2, ) = payable(team2).call {value: newBalance/6}("");
         if (!successfulTeamTransfer2) { emit TeamTransferError(2); }
         
        (bool successfulTeamTransfer3, ) = payable(team3).call {value: newBalance/6}("");
         if (!successfulTeamTransfer3) { emit TeamTransferError(3); }

    }
}