pragma solidity ^0.8.9;

contract AppStorage{
    struct FacetAddressAndPosition {
        address facetAddress;
        uint96 functionSelectorPosition; // position in facetFunctionSelectors.functionSelectors array
    }

    struct FacetFunctionSelectors {
        bytes32[] functionSelectors;
        uint256 facetAddressPosition; // position of facetAddress in facetAddresses array
    }
    
    struct Storage{
        uint256 treasury;
        uint256 budget;
        uint256 period;
        address governanceToken;
        address governor;
        uint256[] availableRights;
        mapping (uint256=>uint256) highestDeadline;
        mapping (address=>uint256) dividends;
        // return erc721 address and token id of given rightid
        mapping (uint256=>bytes32[]) rightsOrigin;
        mapping (uint256=>string) rightUri;
        // rightid and return daily price for rights
        mapping (uint256=>uint256) dailyPrice;
        // receive erc721 address, nftid and return the max number of renters that the nft could have
        mapping (uint256=>uint256) maxRightsHolders;
        // receive erc721 address, nftid and return maximum rental time in days
        mapping (uint256=>uint256) maxtime;
        mapping (address=>uint256[]) rightsOver;
        // receive address and return list of nfts that the address have rights over "[erc721address, nftid]"
        mapping (address=>uint256[]) properties;
        
        // receive erc721 address and nftid and return if is available
        mapping (uint256=>bool) isAvailable;
        // receive erc721 address and nftid and return owner
        mapping (uint256=>address) owner;
        // receive erc721 address and nftid and return list of addresse that have rights over it
        mapping (uint256=>address[]) rightHolders;
        // receive erc721 address, nftid, and rights buyer address and return deadline over that nft
        mapping (uint256=>mapping (address=>uint256)) deadline;
        // receive erc721 address, nftid, and rights buyer address and return rights period in days
        mapping (uint256=>mapping (address=>uint256)) rightsPeriod;

        mapping (uint256=>mapping (address=>mapping (address=>bool))) validated;

        // maps function selector to the facet address and
        // the position of the selector in the facetFunctionSelectors.selectors array
        mapping(bytes32 => FacetAddressAndPosition) selectorToFacetAndPosition;
        // maps facet addresses to function selectors
        mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
        // facet addresses
        address[] facetAddresses;
        // Used to query if a contract implements an interface.
        // Used to implement ERC-165.
        mapping(bytes4 => bool) supportedInterfaces;
        // owner of the contract
        address contractOwner;
    }

    Storage internal appStorage;

    address storageOwner;

    mapping (address=>bool) allowedFacet;

    constructor (address _owner) {
        storageOwner = _owner;
    }

    function addNewAllowedFacet(address _facet) external{
        require(msg.sender == storageOwner, "not the storage owner");
        allowedFacet[_facet] = true;
    }

    function treasury() external view returns(uint256) {
        return appStorage.treasury;
    }

    function setTreasury(uint256 _newTreasury) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.treasury = _newTreasury;
    }

    function budget() external view returns (uint256){
        return appStorage.budget;
    }

    function setBudget(uint256 _newBudget) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.budget = _newBudget;
    }

    function period() external view returns(uint256){
        return appStorage.period;
    }

    function setPeriod(uint256 _newPeriod) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.period = _newPeriod;
    }

    function governanceToken() external view returns (address){
        return appStorage.governanceToken;
    }

    function setGovernanceToken(address _newGovernanceToken) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.governanceToken = _newGovernanceToken;
    }

    function governor() external view returns (address){
        return appStorage.governor;
    }

    function setGovernor(address _newGovernor) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.governor = _newGovernor;
    }

    function availableRights() external view returns (uint256[] memory){
        return appStorage.availableRights;
    }

    function setAvailableRights(uint256[] calldata _newAvailableRights) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.availableRights = _newAvailableRights;
    }

    function highestDeadline(uint256 _id) external view returns (uint256){
        return appStorage.highestDeadline[_id];
    }

    function setHighestDeadline(uint256 _id, uint256 _newDeadline) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.highestDeadline[_id] = _newDeadline;
    }

    function dividends(address _user) external view returns(uint256){
        return appStorage.dividends[_user];
    }

    function setDividends(address _user, uint256 _newDividend) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.dividends[_user] = _newDividend;
    }

    function rightsOrigin(uint256 _id) external view returns(bytes32[] memory){
        return appStorage.rightsOrigin[_id];
    }

    function setRightsOrigin(uint256 _id, bytes32[] calldata _newOrigin) external{
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.rightsOrigin[_id] = _newOrigin;
    }

    function rightUri(uint256 _id) external view returns (string memory){
        return appStorage.rightUri[_id];
    }

    function setRightUri(uint256 _id, string calldata _newUri) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.rightUri[_id] = _newUri;
    }

    function dailyPrice(uint256 _id) external view returns (uint256){
        return appStorage.dailyPrice[_id];
    }

    function setDailyPrice(uint256 _id, uint256 _newDailyPrice) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.dailyPrice[_id] = _newDailyPrice;       
    }   

    function maxRightsHolders(uint256 _id) external view returns (uint256) {
        return appStorage.maxRightsHolders[_id];
    }

    function setMaxRightsHolders(uint256 _id, uint256 _newMaxHolders) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.maxRightsHolders[_id] = _newMaxHolders;       
    }

    function maxtime(uint256 _id) external view returns (uint256) {
        return appStorage.maxtime[_id];
    }

    function setMaxtime(uint256 _id, uint256 _newMaxTime) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.maxtime[_id] = _newMaxTime;       
    }

    function rightsOver(address _user) external view returns (uint256[] memory) {
        return appStorage.rightsOver[_user];
    }

    function setRightsOver(address _user, uint256[] calldata _newRights) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.rightsOver[_user] = _newRights;       
    }

    function properties(address _user) external view returns (uint256[] memory) {
        return appStorage.properties[_user];
    }

    function setProperties(address _user, uint256[] calldata _newProperties) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");    
        appStorage.properties[_user] = _newProperties;   
    }

    function isAvailable(uint256 _id) external view returns (bool) {
        return appStorage.isAvailable[_id];
    }

    function setIsAvailable(uint256 _id, bool _newAvailabilitie) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.isAvailable[_id] = _newAvailabilitie;       
    }

    // owner of the right
    function owner(uint256 _id) external view returns (address) {
        return appStorage.owner[_id];
    }

    function setOwner(uint256 _id, address _newRightOwner) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.owner[_id] = _newRightOwner;       
    }

    function rightHolders(uint256 _id) external view returns (address[] memory) {
        return appStorage.rightHolders[_id];
    }

    function setRightHolders(uint256 _id, address[] calldata _newRightHolders) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.rightHolders[_id] = _newRightHolders;       
    }

    function deadline(uint256 _id, address _user) external view returns (uint256) {
        return appStorage.deadline[_id][_user];
    }

    function setDeadline(uint256 _id, address _user, uint256 _newDeadline) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");   
        appStorage.deadline[_id][_user] = _newDeadline;    
    }

    function rightsPeriod(uint256 _id, address _user) external view returns (uint256) {
        return appStorage.rightsPeriod[_id][_user];
    }

    function setRightsPeriod(uint256 _id, address _user, uint256 _newDeadline) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.rightsPeriod[_id][_user] = _newDeadline;       
    }

    function validated(uint256 _id, address _platform, address _user) external view returns (bool) {
        return appStorage.validated[_id][_platform][_user];
    }

    function setValidated(uint256 _id, address _platform, address _user, bool _validated) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");       
        appStorage.validated[_id][_platform][_user] = _validated;
    }

    function selectorToFacetAndPositionFacet(bytes4 _selector) external view returns (address) {
        return appStorage.selectorToFacetAndPosition[_selector].facetAddress;
    }

    function selectorToFacetAndPositionPosition(bytes4 _selector) external view returns (uint96) {
        return appStorage.selectorToFacetAndPosition[_selector].functionSelectorPosition;
    }

    function deleteSelectorToFacetAndPosition(bytes4 _selector) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        delete appStorage.selectorToFacetAndPosition[_selector];
    }

    function setSelectorToFacetAndPosition(bytes32 _selector, address _facetAddress, uint96 _position) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");       
        appStorage.selectorToFacetAndPosition[_selector].functionSelectorPosition = _position;
        appStorage.selectorToFacetAndPosition[_selector].facetAddress = _facetAddress;
    }

    function facetFunctionSelectorsSelectors(address _facet) external view returns (bytes32[] memory){
        return appStorage.facetFunctionSelectors[_facet].functionSelectors;
    }

    function facetFunctionSelectorsPosition(address _facet) external view returns (uint256) {
        return appStorage.facetFunctionSelectors[_facet].facetAddressPosition;
    }

    function deleteFacetFunctionSelectors(address _facet) external  {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        delete appStorage.facetFunctionSelectors[_facet].facetAddressPosition;
    }

    function setFacetFunctionSelectors(address _facet, bytes32[] calldata _selectors, uint256 _position) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.facetFunctionSelectors[_facet].functionSelectors = _selectors;
        appStorage.facetFunctionSelectors[_facet].facetAddressPosition = _position;
    }

    function facetAddresses() external view returns (address[] memory){
        return appStorage.facetAddresses;
    }

    function facetAddresses(uint256 _position) external view returns (address){
        return appStorage.facetAddresses[_position];
    }

    function setFacetAddresses(address[] calldata _facetAddresses) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.facetAddresses = _facetAddresses;
    }

    function supportedInterfaces(bytes4 _interface) external view returns (bool){
        return appStorage.supportedInterfaces[_interface];       
    }

    function setSupportedInterfaces(bytes4 _interface, bool _supported) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.supportedInterfaces[_interface] = _supported;
    }

    function contractOwner() external view returns (address){
        return appStorage.contractOwner;
    }

    function setContractOwner(address _newOwner) external {
        require(allowedFacet[msg.sender] == true, "not allowed facet");
        appStorage.contractOwner = _newOwner;
    }
}