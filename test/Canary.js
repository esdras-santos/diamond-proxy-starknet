const {assert, expect} = require('chai')
const { deployDiamond } = require('../scripts/deploy-diamond')
const { deployCanaryToken } = require('../scripts/deploy-canary-token')
const { deployCollection } = require('../scripts/deploy-collection')

describe('Canary protocol test', async function(){
    let canaryToken
    let canary
    let collection
    let owner
    let diamondAddress
    let collectionAddress
    let canaryTokenAddress
    let accounts
    let rights

    async function init() {        
        diamondAddress = await deployDiamond()
        canaryTokenAddress = await deployCanaryToken(diamondAddress)
        canaryToken = await ethers.getContractAt('CanaryToken', canaryTokenAddress)
        canary = await ethers.getContractAt('CanaryFacet', diamondAddress)
        collectionAddress = await deployCollection()
        collection = await ethers.getContractAt('Dungeon', collectionAddress)
      
        let tx

        tx = await canary.setGovernanceToken(canaryTokenAddress)
        await tx.wait()
        
        tx = await canaryToken.mint(owner.address, "1000000000000000000")
        await tx.wait()

        tx = await canaryToken.mint(accounts[1].address, "1000000000000000000")
        await tx.wait()

        tx = await canaryToken.mint(accounts[2].address, "1000000000000000000")
        await tx.wait()

        tx = await canaryToken.mint(accounts[3].address, "1000000000000000000")
        await tx.wait()

        tx = await collection.createCollectible("ipfs://bafkreihxwh3yekjq2bakdje4okxpdlsdqlua4jur4iogv2kbyzr6lnawkm")
        await tx.wait()

        tx = await collection.createCollectible("ipfs://bafkreihps5wq65dnaqxs4tgefoqy3qceqm7yl6x3cc7m4ztdqvrflskg2e")
        await tx.wait()

        tx = await collection.createCollectible("ipfs://bafkreiagwvhiyoo3hmoglboczeexmphmnrelrh4dvbfh6agjm3oqewfoya")
        await tx.wait()

        tx = await collection.approve(diamondAddress, '0')
        await tx.wait()
        tx = await collection.approve(diamondAddress, '1')
        await tx.wait()
        tx = await collection.approve(diamondAddress, '2')
        await tx.wait()

        tx = await canary.depositNFT(collectionAddress, '0', '3000000000000000', '30', '10')
        await tx.wait()
        tx = await canary.depositNFT(collectionAddress, '1', '9000000000000000', '30', '10')
        await tx.wait()
        tx = await canary.depositNFT(collectionAddress, '2', '20000000000000000', '30', '2')
        await tx.wait()
        rights = await canary.getAvailableNFTs()
    }

    before(async function(){
        accounts = await ethers.getSigners()
        owner = accounts[0]

        await init()
    })

    beforeEach(async function(){
        await init()
    })

    it('should test the deposit of NFTs into the protocol', async function(){
        
        let NFTOwner
        
        assert.equal(rights.length, 3)
        NFTOwner = await canary.ownerOf(rights[0])        
        assert.equal(NFTOwner, owner.address)
        NFTOwner = await canary.ownerOf(rights[1])        
        assert.equal(NFTOwner, owner.address)
        NFTOwner = await canary.ownerOf(rights[2])        
        assert.equal(NFTOwner, owner.address)

        let availableRights
        availableRights = await canary.availableRightsOf(rights[0])
        assert.equal(availableRights, 10)
        availableRights = await canary.availableRightsOf(rights[1])
        assert.equal(availableRights, 10)
        availableRights = await canary.availableRightsOf(rights[2])
        assert.equal(availableRights, 2)

        let rightsPrice
        rightsPrice = await canary.dailyPriceOf(rights[0])
        assert.equal(rightsPrice, '3000000000000000')
        rightsPrice = await canary.dailyPriceOf(rights[1])
        assert.equal(rightsPrice, '9000000000000000')
        rightsPrice = await canary.dailyPriceOf(rights[2])
        assert.equal(rightsPrice, '20000000000000000')     
        
        let maxPeriod
        maxPeriod = await canary.maxPeriodOf(rights[0])
        assert.equal(maxPeriod, 30)
        maxPeriod = await canary.maxPeriodOf(rights[1])
        assert.equal(maxPeriod, 30)
        maxPeriod = await canary.maxPeriodOf(rights[2])
        assert.equal(maxPeriod, 30)

        let origin = []
        origin = await canary.originOf(rights[0])
        assert.equal('0x'+origin[0].substring(26), collection.address.toLowerCase())
        assert.equal(Number(origin[1]), 0)
        origin = await canary.originOf(rights[1])
        assert.equal('0x'+origin[0].substring(26), collection.address.toLowerCase())
        assert.equal(Number(origin[1]), 1)
        origin = await canary.originOf(rights[2])
        assert.equal('0x'+origin[0].substring(26), collection.address.toLowerCase())
        assert.equal(Number(origin[1]), 2)
    })

    it('should test the getRights method', async function(){
        let tx
        let dailyPrice
        await expect(
            canary.getRights('00000000000000000000000000000000000000000000000000000000000000000000', '10', {value: '0'})
        ).to.be.revertedWith('NFT is not available')
        dailyPrice = await canary.dailyPriceOf(rights[0])
        
        await expect(
            canary.getRights(rights[0], '31')
        ).to.be.revertedWith('period is above the max period')

        dailyPrice = await canary.dailyPriceOf(rights[2])
        await canaryToken.connect(accounts[1]).approve(canary.address, `${Number(dailyPrice)*30}`)
        tx = await canary.connect(accounts[1]).getRights(rights[2], '30')
        await tx.wait()

        await canaryToken.connect(accounts[2]).approve(canary.address, `${Number(dailyPrice)*30}`)
        tx = await canary.connect(accounts[2]).getRights(rights[2], '30')
        await tx.wait()

        await expect(
            canary.connect(accounts[3]).getRights(rights[2], '30')
        ).to.be.revertedWith('limit of right holders reached')

        dailyPrice = await canary.dailyPriceOf(rights[1])
        await canaryToken.connect(accounts[1]).approve(canary.address, `${Number(dailyPrice)*30}`)
        tx = await canary.connect(accounts[1]).getRights(rights[1], '30')
        await tx.wait()

        await expect(
            canary.connect(accounts[1]).getRights(rights[1], '30')
        ).to.be.revertedWith('already buy this right')

        await expect(
            canary.getRights(rights[1], '0')
        ).to.be.revertedWith('period is equal to 0')

        let rightsOf
        rightsOf = await canary.rightsOf(accounts[1].address)
        assert.equal(rightsOf[0].value, rights[2].value)
    })

    it('should test the setAvailability function', async function(){
        let availability
        availability = await canary.availabilityOf(rights[1])
        assert.equal(availability, true)
        await expect(
            canary.connect(accounts[1]).setAvailability(rights[1], false,'1')
        ).to.be.revertedWith('only the NFT Owner')
        
        await expect(
            canary.setAvailability(rights[1], false,'2')
        ).to.be.revertedWith('wrong index for rightid')

        let aux = rights[1]
        let tx
        tx = await canary.setAvailability(rights[1], false,'1')
        await tx.wait()

        rights = await canary.getAvailableNFTs()
        assert.equal(rights.length, 2)

        availability = await canary.availabilityOf(aux)
        assert.equal(availability, false)

        // in this case the index doesn't matter
        tx = await canary.setAvailability(aux, true,'0')
        await tx.wait()

        rights = await canary.getAvailableNFTs()
        assert.equal(rights.length, 3)

        availability = await canary.availabilityOf(rights[2])
        assert.equal(availability, true)

        assert.equal(aux.value, rights[2].value)
    })

    it('should test the withdrawRoyalties function', async function(){
        let tx
        let dailyPrice
        let rightHolders
        dailyPrice = await canary.dailyPriceOf(rights[0])
        await canaryToken.connect(accounts[1]).approve(canary.address, `${Number(dailyPrice)*1}`)
        tx = await canary.connect(accounts[1]).getRights(rights[0], '1')
        await tx.wait()
        rightHolders = await canary.rightHoldersOf(rights[0])
        assert.equal(accounts[1].address, rightHolders[0])

        await canaryToken.connect(accounts[2]).approve(canary.address, `${Number(dailyPrice)*3}`)
        tx = await canary.connect(accounts[2]).getRights(rights[0], '3')
        await tx.wait()
        rightHolders = await canary.rightHoldersOf(rights[0])
        assert.equal(accounts[2].address, rightHolders[1])

        await canaryToken.connect(accounts[3]).approve(canary.address, `${Number(dailyPrice)*5}`)
        tx = await canary.connect(accounts[3]).getRights(rights[0], '5')
        await tx.wait()
        rightHolders = await canary.rightHoldersOf(rights[0])
        assert.equal(accounts[3].address, rightHolders[2])

        await expect(
            canary.withdrawRoyalties(rights[1])
        ).to.be.revertedWith('right does not exists')

        var currentDateTime = new Date();
        await network.provider.send("evm_setNextBlockTimestamp", [parseInt((currentDateTime.getTime()/ 1000)) + (86400 * 30)])
        await network.provider.send("evm_mine")
        const latestBlock = await ethers.provider.getBlock("latest")
        
        let expectedRoyaltie = 0
        for(rh of rightHolders){
            let deadline = await canary.holderDeadline(rights[0], rh)
            let rightsPeriod = await canary.rightsPeriodOf(rights[0], rh)
            if(Number(deadline) < Number(latestBlock.timestamp)){
                let amount = Number(dailyPrice) * Number(rightsPeriod)
                expectedRoyaltie += amount - (amount * 500 / 10000)  
                 
            }
        }    
        await expect(canary.withdrawRoyalties(rights[0]))
            .to.emit(canary, 'RoyaltiesWithdraw')
            .withArgs(owner.address, expectedRoyaltie.toString())
        
    })

    it("it should test the withdrawNFT function", async function(){
        let tx
        let dailyPrice = await canary.dailyPriceOf(rights[0])
        await canaryToken.connect(accounts[1]).approve(canary.address, `${Number(dailyPrice)*1}`)
        tx = await canary.connect(accounts[1]).getRights(rights[0], '1')
        await tx.wait()
        let properties = await canary.propertiesOf(owner.address)
        let i = 0
        for(p of properties){
            if(p.toString() === rights[0].toString()){
                break
            }
            i++
        }
        await expect(
            canary.withdrawNFT(rights[0], i)
        ).to.be.revertedWith('highest right deadline should end before withdraw')
        var currentDateTime = new Date();
        await network.provider.send("evm_setNextBlockTimestamp", [parseInt(currentDateTime.getTime()/ 1000) + (86400 * 32)])
        await network.provider.send("evm_mine")

        await expect(
            canary.withdrawNFT(rights[0], i)
        ).to.be.revertedWith('NFT should be unavailable')

        let available = await canary.getAvailableNFTs()
        let j = 0
        for(a of available){
            if(a.toString() === rights[0].toString()){
                break
            }
            j++
        }
        
        tx = await canary.setAvailability(rights[0], false, j)
        await tx.wait()

        await expect(
            canary.withdrawNFT(rights[0], i+1)
        ).to.be.revertedWith('wrong index for collection address')

        let origin = await canary.originOf(rights[0])

        tx = await canary.withdrawNFT(rights[0], i)
        await tx.wait()
      
        let o = await collection.ownerOf(origin[1])
        assert.equal(o, owner.address)
    })

    it("should test the incentive model", async function() {
        let tx
        
        tx = await canaryToken.mint(accounts[4].address, "1000000000000000000")
        await tx.wait()

        tx = await canaryToken.mint(accounts[5].address, "1000000000000000000")
        await tx.wait()
        
        let dailyPrice = await canary.dailyPriceOf(rights[2])
        await canaryToken.connect(accounts[4]).approve(canary.address, `${Number(dailyPrice)*1}`)
        tx = await canary.connect(accounts[4]).getRights(rights[2], '1')
        await tx.wait()

        await expect(
            canary.verifyRight(rights[2], accounts[4].address)
        ).to.be.revertedWith('the platform cannot be the right holder')

        await expect(
            canary.connect(accounts[5]).verifyRight(rights[2], accounts[6].address)
        ).to.be.revertedWith('sender is not the right holder')

        var currentDateTime = new Date();
        await network.provider.send("evm_setNextBlockTimestamp", [parseInt(currentDateTime.getTime()/ 1000) + (86400 * 34)])
        await network.provider.send("evm_mine")

        await expect(
            canary.connect(accounts[4]).verifyRight(rights[2], accounts[6].address)
        ).to.be.revertedWith('has exceeded the right time')

        
        await canaryToken.connect(accounts[5]).approve(canary.address, `${Number(dailyPrice)*1}`)
        tx = await canary.connect(accounts[5]).getRights(rights[2], '1')
        await tx.wait()

        tx = await canary.connect(accounts[5]).verifyRight(rights[2], accounts[6].address)
        await tx.wait()

        await expect(
            canary.connect(accounts[5]).verifyRight(rights[2], accounts[6].address)
        ).to.be.revertedWith('rightid and right holder are already validated')

        let verified = await canary.connect(accounts[5]).verified(rights[2], accounts[6].address)
        
        assert.equal(verified, true)

        let balance = await canaryToken.balanceOf(accounts[6].address)

        assert.equal(balance, dailyPrice/2)
        
    })
})