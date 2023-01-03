//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../storage/AppStorage.sol";
import { LibDiamond } from  "../libraries/LibDiamond.sol";
import "hardhat/console.sol";

interface ERC721Metadata{
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

interface IERC721{
    function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
}

interface Token{
    function mint(address _platform, uint256 _amount) external;
    function burn(address _platform, uint256 _amount) external;
    function transfer(address _to, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
}

contract Canary{
    AppStorage appStorage = LibDiamond.diamondStorage();

    event GetRight(uint256 _rightid, uint256 _period, address _who);
    event DepositedNFT(address _erc721, uint256 _nftid);
    event RoyaltiesWithdraw(address owner, uint256 amount);

    modifier isNFTOwner(uint256 _rightid){
        require(appStorage.owner(_rightid) == msg.sender, "only the NFT Owner");
        _;
    }

    function getRights(uint256 _rightid, uint256 _period) external{
        require(appStorage.isAvailable(_rightid),"NFT is not available");
        require(appStorage.maxtime(_rightid) >= _period,"period is above the max period");
        require(appStorage.maxRightsHolders(_rightid) > 0, "limit of right holders reached");
        require(appStorage.rightsPeriod(_rightid,msg.sender) == 0,"already buy this right");
        require(_period > 0, "period is equal to 0");
        Token ct = Token(appStorage.governanceToken());
        // take 5% of the right amount as fee
        appStorage.setMaxRightsHolders(_rightid ,appStorage.maxRightsHolders(_rightid) - 1);
        uint256 value = appStorage.dailyPrice(_rightid) * _period;
        ct.transferFrom(msg.sender, address(this), value);
        appStorage.setTreasury(appStorage.treasury() + value * 500 / 10000);
        
        appStorage.setRightsPeriod(_rightid, msg.sender, _period);
        uint256[] memory rightsOver = appStorage.rightsOver(msg.sender);
        rightsOver[rightsOver.length] = _rightid;
        appStorage.setRightsOver(msg.sender, rightsOver);
        appStorage.setDeadline(_rightid, msg.sender , block.timestamp + (1 days * _period));
        
        if(block.timestamp + (1 days * _period) > appStorage.highestDeadline(_rightid)){
            appStorage.setHighestDeadline(_rightid, block.timestamp + (1 days * _period));
        }
        address[] memory rightHolders = appStorage.rightHolders(_rightid);
        rightHolders[rightHolders.length] = msg.sender;
        appStorage.setRightHolders(_rightid, rightHolders);
        
        emit GetRight(_rightid, _period, msg.sender);
    }

    // need to call approval before calling this function
    function depositNFT(
        address _erc721, 
        uint256 _nftid, 
        uint256 _dailyPrice, 
        uint256 _maxPeriod,
        uint256 _amount) 
        external 
    {
        require(_erc721 != address(0x00), "collection address is zero");
        ERC721Metadata e721metadata = ERC721Metadata(_erc721);
        string memory uri = e721metadata.tokenURI(_nftid);
        _mint(_erc721, _nftid, _amount, _dailyPrice, _maxPeriod, uri);
        IERC721 e721 = IERC721(_erc721);
        e721.transferFrom(msg.sender, address(this), _nftid);
        emit DepositedNFT(_erc721, _nftid);
    }

    // due to his high complexity (O(N^4)) this function is only viable in StarkNet
    function withdrawRoyalties(
        uint256 _rightid) 
        external isNFTOwner(_rightid)
    {
        
        require(appStorage.rightHolders(_rightid).length > 0, "right does not exists");
        uint256 amountToWithdraw = 0;
        uint256 j = 0;
        Token ct = Token(appStorage.governanceToken());
        
        while(appStorage.rightHolders(_rightid).length > 0){
            uint256 dl = appStorage.deadline(_rightid, appStorage.rightHolders(_rightid)[j]);
            uint256 rp = appStorage.rightsPeriod(_rightid, appStorage.rightHolders(_rightid)[j]);
            if(dl < block.timestamp){
                uint256 amount = (appStorage.dailyPrice(_rightid) * rp);
                // subtract the fee
                amountToWithdraw += amount - (amount * 500 / 10000);  
                for(uint256 i; i < appStorage.rightsOver(appStorage.rightHolders(_rightid)[j]).length; i++){
                    if(appStorage.rightsOver(appStorage.rightHolders(_rightid)[j])[i] == _rightid){
                        uint256[] memory rightsOver = appStorage.rightsOver(appStorage.rightHolders(_rightid)[j]);
                        rightsOver[i] =  rightsOver[rightsOver.length-1];
                        for(uint256 c; c < rightsOver.length - 2; c++){
                            rightsOver[c] = rightsOver[c];
                        }
                        appStorage.setRightsOver(appStorage.rightHolders(_rightid)[j], rightsOver);  
                        break;          
                    }
                } 
                appStorage.setDeadline(_rightid, appStorage.rightHolders(_rightid)[j], 0);
                appStorage.setRightsPeriod(_rightid, appStorage.rightHolders(_rightid)[j], 0);

                address[] memory rightHolders = appStorage.rightHolders(_rightid);
                rightHolders[j] = rightHolders[rightHolders.length-1];
                for(uint256 c; c < rightHolders.length - 2; c++){
                    rightHolders[c] = rightHolders[c];
                }
                appStorage.setRightHolders(_rightid, rightHolders);

                appStorage.setMaxRightsHolders(_rightid, appStorage.maxRightsHolders(_rightid) + 1);
            }
        }
        emit RoyaltiesWithdraw(msg.sender, amountToWithdraw);
        ct.transfer(msg.sender, amountToWithdraw);
    }

    function withdrawNFT(uint256 _rightid) external isNFTOwner(_rightid) {
        require(appStorage.highestDeadline(_rightid) < block.timestamp, "highest right deadline should end before withdraw");
        require(appStorage.isAvailable(_rightid) == false, "NFT should be unavailable");
        // conversion not allowed from "uint160" to "address" due to Warp change in address size to 251 bits
        // so the conversion will be from "uint256" to "address"
        uint256 rightindex;
        for(uint256 i; i< appStorage.properties(msg.sender).length; i++){
            if(appStorage.properties(msg.sender)[i] == _rightid){
                rightindex = i;
                break;
            }
        }
        address erc721 = address(uint160(uint256(appStorage.rightsOrigin(_rightid)[0])));
        uint256 nftid = uint256(appStorage.rightsOrigin(_rightid)[1]);
        _burn(_rightid, rightindex);
        appStorage.setHighestDeadline(_rightid, 0);
        IERC721 e721 = IERC721(erc721);
        e721.transferFrom(address(this), msg.sender, nftid);
    }

    function setAvailability( 
        uint256 _rightid, 
        bool _available) 
        external isNFTOwner(_rightid) 
    {
        uint256 _nftindex;
        for(uint256 i;i<appStorage.availableRights().length-1;i++){
            if(appStorage.availableRights()[i]  == _rightid){
                _nftindex = i;
                break;
            }
        }
        if(_available == false){
            uint256[] memory availableRights = appStorage.availableRights();
            availableRights[_nftindex] = availableRights[availableRights.length-1];
            for(uint256 i; i< availableRights.length - 2; i++){
                availableRights[i] = availableRights[i];
            }
            appStorage.setAvailableRights(availableRights);
        } else {
            uint256[] memory availableRights = appStorage.availableRights();
            availableRights[availableRights.length] = _rightid;
            appStorage.setAvailableRights(availableRights);
        }
        appStorage.setIsAvailable(_rightid, _available);
    }

    function verifyRight(uint256 _rightid, address _platform) external{
        
        require(appStorage.rightsPeriod(_rightid, _platform) == 0, "the platform cannot be the right holder");
        require(appStorage.rightsPeriod(_rightid, msg.sender) > 0, "sender is not the right holder");
        require(appStorage.deadline(_rightid, msg.sender) > block.timestamp,"has exceeded the right time");
        require(appStorage.validated(_rightid, _platform, msg.sender) == false, "rightid and right holder are already validated");
        appStorage.setValidated(_rightid, _platform, msg.sender, true);
        Token ct = Token(appStorage.governanceToken());
        ct.mint(_platform, appStorage.dailyPrice(_rightid)/2);
    }

    function verified(uint256 _rightid, address _platform) external view returns(bool){
        
        return appStorage.validated(_rightid, _platform, msg.sender);
    }

    function _mint(
        address _erc721, 
        uint256 _nftid, 
        uint256 _amount,
        uint256 _dailyPrice,
        uint256 _maxPeriod, 
        string memory _nftUri) 
        internal 
    {
        
        uint256 rightid = uint256(keccak256(abi.encode(_erc721, _nftid)));
        appStorage.setMaxRightsHolders(rightid, _amount);
        appStorage.setDailyPrice(rightid, _dailyPrice);
        appStorage.setMaxtime(rightid, _maxPeriod);
        appStorage.setOwner(rightid, msg.sender);
        // conversion not allowed from "uint160" to "address" due to Warp change in address size to 251 bits
        // so the conversion will be from "uint256" to "address"
        bytes32[] memory rightsOrigin = appStorage.rightsOrigin(rightid);
        rightsOrigin[rightsOrigin.length] = bytes32(uint256(uint160(_erc721)));
        rightsOrigin[rightsOrigin.length] = bytes32(_nftid);
        appStorage.setRightUri(rightid, _nftUri);
        appStorage.setIsAvailable(rightid, true);
        uint256[] memory properties = appStorage.properties(msg.sender);
        properties[properties.length] = rightid;
        appStorage.setProperties(msg.sender, properties);
        uint256[] memory availableRights = appStorage.availableRights();
        availableRights[availableRights.length] = rightid;
    }

    function _burn(uint256 _rightid, uint256 _rightIndex) internal{
        
        appStorage.setMaxRightsHolders(_rightid, 0);
        appStorage.setDailyPrice(_rightid, 0);
        appStorage.setMaxtime(_rightid, 0);
        bytes32[] memory rightsOrigin = appStorage.rightsOrigin(_rightid);
        for(uint256 i; i < rightsOrigin.length -2; i++){
            rightsOrigin[i] = rightsOrigin[i];
        }
        appStorage.setRightsOrigin(_rightid, rightsOrigin);
        uint256[] memory properties = appStorage.properties(msg.sender);
        properties[_rightIndex] = properties[properties.length-1];
        for(uint256 i; i < properties.length -1; i++){
            properties[i] =properties[i];
        }
        appStorage.setProperties(msg.sender, properties);
        appStorage.setRightUri(_rightid, "");
        appStorage.setOwner(_rightid, address(0x00));
    }

    function setGovernanceToken(address _newToken) external{
        require(appStorage.contractOwner() == msg.sender);
        appStorage.setGovernanceToken(_newToken);
    }

    function currentTreasury() external view returns (uint256){
        
        return appStorage.treasury();
    }

    function dailyPriceOf(uint256 _rightid) external view returns (uint256) {
        
        return appStorage.dailyPrice(_rightid);
    }

    function availableRightsOf(uint256 _rightid) external view returns (uint256) {
        
        return appStorage.maxRightsHolders(_rightid);
    }

    function maxPeriodOf(uint256 _rightid) external view returns (uint256) {
        
        return appStorage.maxtime(_rightid);
    }

    function rightsPeriodOf(uint256 _rightid, address _holder) external view returns (uint256){
        
        return appStorage.rightsPeriod(_rightid, _holder);
    }

    function rightsOf(address _rightsHolder) external view returns (uint256[] memory) {
        
        return appStorage.rightsOver(_rightsHolder);
    }

    function propertiesOf(address _owner) external view returns (uint256[] memory) {
        
        return appStorage.properties(_owner);
    }

    function getAvailableNFTs() external view returns (uint256[] memory) {
        
        return appStorage.availableRights();
    }

    function rightHoldersOf(uint256 _rightid) external view returns (address[] memory){
        
        return appStorage.rightHolders(_rightid);
    }

    function holderDeadline(uint256 _rightid, address _holder) external view returns (uint256){
        
        return appStorage.deadline(_rightid, _holder);
    }

    function ownerOf(uint256 _rightid) external view returns (address){
        
        return appStorage.owner(_rightid);
    }

    function availabilityOf(uint256 _rightid) external view returns (bool){
        
        return appStorage.isAvailable(_rightid);
    }

    function rightURI(uint256 _rightid) external view returns (string memory){
        
        return appStorage.rightUri(_rightid);
    }

    function originOf(uint256 _rightid) external view returns (bytes32[] memory){
        
        return appStorage.rightsOrigin(_rightid);
    }
}
