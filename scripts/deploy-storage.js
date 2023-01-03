const {hardcodeAddress} = require('./hardcode-storage-address')

async function deployStorage(diamondAddress) {

    const Storage = await ethers.getContractFactory('AppStorage')
    const storage = await Storage.deploy(diamondAddress)
    await storage.deployed()
    hardcodeAddress(storage.address)
    return storage.address
}

exports.deployStorage = deployStorage