async function deployCanaryToken(diamondAddress) {
    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

    const Dungeon = await ethers.getContractFactory('CanaryToken')
    const dungeon = await Dungeon.deploy(contractOwner, diamondAddress)
    await dungeon.deployed()
    
    return dungeon.address
}

exports.deployCanaryToken = deployCanaryToken