async function deployCollection() {
    const accounts = await ethers.getSigners()
    const contractOwner = accounts[0]

    const Dungeon = await ethers.getContractFactory('Dungeon')
    const dungeon = await Dungeon.deploy()
    await dungeon.deployed()
    
    return dungeon.address
}

exports.deployCollection = deployCollection