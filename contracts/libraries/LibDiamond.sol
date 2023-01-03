// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/******************************************************************************\
* Author: Nick Mudge <nick@perfectabstractions.com> (https://twitter.com/mudgen)
* EIP-2535 Diamonds: https://eips.ethereum.org/EIPS/eip-2535
/******************************************************************************/
import "../storage/AppStorage.sol";
import { IDiamondCut } from "../interfaces/IDiamondCut.sol";


// Remember to add the loupe functions from DiamondLoupeFacet to the diamond.
// The loupe functions are required by the EIP2535 Diamonds standard

library LibDiamond {
    // repeat this through all the facets
    address constant appStorageAddress = address(0x1234567890123456789012345678901234567890);
    bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("diamond.standard.diamond.storage");


    // struct DiamondStorage {
    //     uint256 treasury;
    //     uint256 budget;
    //     uint256 period;
    //     address governanceToken;
    //     address governor;
    //     uint256[] availableRights;
    //     mapping (uint256=>uint256) highestDeadline;
    //     mapping (address=>uint256) dividends;
    //     // tracks price before approval of the proposal
    //     mapping (uint256=>uint256) beforeProposal;
    //     // return erc721 address and token id of given rightid
    //     mapping (uint256=>bytes32[]) rightsOrigin;
    //     mapping (uint256=>string) rightUri;
    //     // rightid and return daily price for rights
    //     mapping (uint256=>uint256) dailyPrice;
    //     // receive erc721 address, nftid and return the max number of renters that the nft could have
    //     mapping (uint256=>uint256) maxRightsHolders;
    //     // receive erc721 address, nftid and return maximum rental time in days
    //     mapping (uint256=>uint256) maxtime;
    //     mapping (address=>uint256[]) rightsOver;
    //     // receive address and return list of nfts that the address have rights over "[erc721address, nftid]"
    //     mapping (address=>uint256[]) properties;
        
    //     // receive erc721 address and nftid and return if is available
    //     mapping (uint256=>bool) isAvailable;
    //     // receive erc721 address and nftid and return owner
    //     mapping (uint256=>address) owner;
    //     // receive erc721 address and nftid and return list of addresse that have rights over it
    //     mapping (uint256=>address[]) rightHolders;
    //     // receive erc721 address, nftid, and rights buyer address and return deadline over that nft
    //     mapping (uint256=>mapping (address=>uint256)) deadline;
    //     // receive erc721 address, nftid, and rights buyer address and return rights period in days
    //     mapping (uint256=>mapping (address=>uint256)) rightsPeriod;

    //     mapping (uint256=>mapping (address=>mapping (address=>bool))) validated;

    //     // maps function selector to the facet address and
    //     // the position of the selector in the facetFunctionSelectors.selectors array
    //     mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
    //     // maps facet addresses to function selectors
    //     mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
    //     // facet addresses
    //     address[] facetAddresses;
    //     // Used to query if a contract implements an interface.
    //     // Used to implement ERC-165.
    //     mapping(bytes4 => bool) supportedInterfaces;
    //     // owner of the contract
    //     address contractOwner;
    // }

    function diamondStorage() internal pure returns (AppStorage) {
        AppStorage appStorage = AppStorage(appStorageAddress);
        return appStorage;
    }

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function setContractOwner(address _newOwner) internal {
        AppStorage appStorage = diamondStorage();
        address previousOwner = appStorage.contractOwner();
        appStorage.setContractOwner(_newOwner);
        emit OwnershipTransferred(previousOwner, _newOwner);
    }

    function contractOwner() internal view returns (address contractOwner_) {
        AppStorage appStorage = diamondStorage();
        contractOwner_ = appStorage.contractOwner();
    }

    function enforceIsContractOwner() internal view {
        AppStorage appStorage = diamondStorage();
        require(msg.sender == appStorage.contractOwner(), "LibDiamond: Must be contract owner");
    }

    event DiamondCut(IDiamondCut.FacetCut[] _diamondCut, address _init, bytes _calldata);

    // Internal function version of diamondCut
    function diamondCut(
        IDiamondCut.FacetCut[] memory _diamondCut,
        address _init,
        bytes memory _calldata
    ) internal {
        for (uint256 facetIndex; facetIndex < _diamondCut.length; facetIndex++) {
            IDiamondCut.FacetCutAction action = _diamondCut[facetIndex].action;
            if (action == IDiamondCut.FacetCutAction.Add) {
                addFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Replace) {
                replaceFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else if (action == IDiamondCut.FacetCutAction.Remove) {
                removeFunctions(_diamondCut[facetIndex].facetAddress, _diamondCut[facetIndex].functionSelectors);
            } else {
                revert("LibDiamondCut: Incorrect FacetCutAction");
            }
        }
        emit DiamondCut(_diamondCut, _init, _calldata);
        initializeDiamondCut(_init, _calldata);
    }

    function addFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        AppStorage appStorage = diamondStorage();
        require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
        require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
        uint96 selectorPosition = uint96(appStorage.facetFunctionSelectors(_facetAddress).functionSelectors.length);
        // add new facet address if it does not exist
        if (selectorPosition == 0) {
            addFacet(_facetAddress);            
        }
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = appStorage.selectorToFacetAndPosition(selector).facetAddress;
            require(oldFacetAddress == address(0), "LibDiamondCut: Can't add function that already exists");
            addFunction( selector, selectorPosition, _facetAddress);
            selectorPosition++;
        }
    }

    function replaceFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        AppStorage appStorage = diamondStorage();
        require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
        require(_facetAddress != address(0), "LibDiamondCut: Add facet can't be address(0)");
        uint96 selectorPosition = uint96(appStorage.facetFunctionSelectors(_facetAddress).functionSelectors.length);
        // add new facet address if it does not exist
        if (selectorPosition == 0) {
            addFacet(_facetAddress);
        }
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = appStorage.selectorToFacetAndPosition(selector).facetAddress;
            require(oldFacetAddress != _facetAddress, "LibDiamondCut: Can't replace function with same function");
            removeFunction(oldFacetAddress, selector);
            addFunction(selector, selectorPosition, _facetAddress);
            selectorPosition++;
        }
    }

    function removeFunctions(address _facetAddress, bytes4[] memory _functionSelectors) internal {
        AppStorage appStorage = diamondStorage();
        require(_functionSelectors.length > 0, "LibDiamondCut: No selectors in facet to cut");
        // if function does not exist then do nothing and return
        require(_facetAddress == address(0), "LibDiamondCut: Remove facet address must be address(0)");
        for (uint256 selectorIndex; selectorIndex < _functionSelectors.length; selectorIndex++) {
            bytes4 selector = _functionSelectors[selectorIndex];
            address oldFacetAddress = appStorage.selectorToFacetAndPosition(selector).facetAddress;
            removeFunction(oldFacetAddress, selector);
        }
    }

    function addFacet(address _facetAddress) internal {
        AppStorage appStorage = diamondStorage();
        enforceHasContractCode(_facetAddress, "LibDiamondCut: New facet has no code");
        address[] memory facetAddresses = appStorage.facetAddresses();
        bytes4[] memory functionSelectors = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors;
        appStorage.setFacetFunctionSelectors(_facetAddress, functionSelectors, facetAddresses.length);
        facetAddresses[facetAddresses.length] = _facetAddress;
        appStorage.setFacetAddresses(facetAddresses);
    }    


    function addFunction(bytes4 _selector, uint96 _selectorPosition, address _facetAddress) internal {
        AppStorage appStorage = diamondStorage();
        appStorage.setSelectorToFacetAndPosition(_selector, _facetAddress, _selectorPosition);
        bytes4[] memory functionSelectors = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors;
        uint256 position = appStorage.facetFunctionSelectors(_facetAddress).facetAddressPosition;
        functionSelectors[functionSelectors.length] = _selector;
        appStorage.setFacetFunctionSelectors(_facetAddress, functionSelectors, position);
    }

    function removeFunction(address _facetAddress, bytes4 _selector) internal {        
        AppStorage appStorage = diamondStorage();
        require(_facetAddress != address(0), "LibDiamondCut: Can't remove function that doesn't exist");
        // an immutable function is a function defined directly in a diamond
        require(_facetAddress != address(this), "LibDiamondCut: Can't remove immutable function");
        // replace selector with last selector, then delete last selector
        uint256 selectorPosition = appStorage.selectorToFacetAndPosition(_selector).functionSelectorPosition;
        uint256 lastSelectorPosition = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors.length - 1;
        // if not the same then replace _selector with lastSelector
        if (selectorPosition != lastSelectorPosition) {
            bytes4 lastSelector = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors[lastSelectorPosition];
            bytes4[] memory selectors = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors;
            selectors[selectorPosition] = lastSelector;
            uint256 position = appStorage.facetFunctionSelectors(_facetAddress).facetAddressPosition;
            appStorage.setFacetFunctionSelectors(_facetAddress, selectors, position);

            address facet = appStorage.selectorToFacetAndPosition(_selector).facetAddress;
            appStorage.setSelectorToFacetAndPosition(lastSelector, facet, uint96(selectorPosition));
        }
        // delete the last selector
        bytes4[] memory functionSelectors = appStorage.facetFunctionSelectors(_facetAddress).functionSelectors;
        for(uint256 i; i < functionSelectors.length - 2; i++){
            functionSelectors[1] = functionSelectors[i]; 
        }
        appStorage.deleteSelectorToFacetAndPosition(_selector);

        // if no more selectors for facet address then delete the facet address
        if (lastSelectorPosition == 0) {
            // replace facet address with last facet address and delete last facet address
            uint256 lastFacetAddressPosition = appStorage.facetAddresses().length - 1;
            uint256 facetAddressPosition = appStorage.facetFunctionSelectors(_facetAddress).facetAddressPosition;
            if (facetAddressPosition != lastFacetAddressPosition) {
                address lastFacetAddress = appStorage.facetAddresses(lastFacetAddressPosition);
                address[] memory _facetAddresses = appStorage.facetAddresses();
                _facetAddresses[facetAddressPosition] = lastFacetAddress;
                appStorage.setFacetAddresses(_facetAddresses);
                bytes4[] memory selectors = appStorage.facetFunctionSelectors(lastFacetAddress).functionSelectors;
                appStorage.setFacetFunctionSelectors(lastFacetAddress, selectors, facetAddressPosition);
            }
            address[] memory facetAddresses = appStorage.facetAddresses();
            for(uint256 i; i < facetAddresses.length - 2; i++){
                facetAddresses[i] = facetAddresses[i];
            }
            appStorage.setFacetAddresses(facetAddresses);
            appStorage.deleteFacetFunctionSelectors(_facetAddress);
        }
    }

    function initializeDiamondCut(address _init, bytes memory _calldata) internal {
        if (_init == address(0)) {
            require(_calldata.length == 0, "LibDiamondCut: _init is address(0) but_calldata is not empty");
        } else {
            require(_calldata.length > 0, "LibDiamondCut: _calldata is empty but _init is not address(0)");
            if (_init != address(this)) {
                enforceHasContractCode(_init, "LibDiamondCut: _init address has no code");
            }
            (bool success, bytes memory error) = _init.delegatecall(_calldata);
            if (!success) {
                if (error.length > 0) {
                    // bubble up the error
                    revert(string(error));
                } else {
                    revert("LibDiamondCut: _init function reverted");
                }
            }
        }
    }

    function enforceHasContractCode(address _contract, string memory _errorMessage) internal view {
        uint256 contractSize;
        assembly {
            contractSize := extcodesize(_contract)
        }
        require(contractSize > 0, _errorMessage);
    }
}