import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
import Morfi from "../contracts/Morfi.cdc"
import MetadataViews from "../contracts/standard/MetadataViews.cdc"
import FlowToken from "../contracts/standard/FlowToken.cdc"


transaction(metadataId: UInt64) {

    let PaymentVault: &FlowToken.Vault
    let CollectionPublic: &Morfi.Collection{NonFungibleToken.Receiver}

    prepare(signer: AuthAccount) {
        // Setup
        if signer.borrow<&Morfi.Collection>(from: Morfi.CollectionStoragePath) == nil {
            signer.save(<- Morfi.createEmptyCollection(), to: Morfi.CollectionStoragePath)
            signer.link<&Morfi.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(Morfi.CollectionPublicPath, target: Morfi.CollectionStoragePath)
        }

        var paymentPath: StoragePath = /storage/flowTokenVault

        self.PaymentVault = signer.borrow<&FlowToken.Vault>(from: paymentPath)!

        self.CollectionPublic = signer.getCapability(Morfi.CollectionPublicPath)
                              .borrow<&Morfi.Collection{NonFungibleToken.Receiver}>()
                              ?? panic("Did not properly set up the Morfi NFT Collection.")

    }

    execute {
        let payment: @FlowToken.Vault <- self.PaymentVault.withdraw(amount: 1.0) as! @FlowToken.Vault
        let nftId = Morfi.mintNFT(metadataId: metadataId, recipient: self.CollectionPublic, payment: <- payment)
        log("An NFT has been minted successfully!")
    }

}
