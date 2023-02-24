import NonFungibleToken from "../contracts/standard/NonFungibleToken.cdc"
import Morfi from "../contracts/Morfi.cdc"
import MetadataViews from "../contracts/standard/MetadataViews.cdc"

// This transaction configures an account to hold a Morfi NFT.

transaction {
    prepare(signer: AuthAccount) {
        // if the account doesn't already have a collection
        if signer.borrow<&Morfi.Collection>(from: Morfi.CollectionStoragePath) == nil {

            // create a new empty collection
            let collection <- Morfi.createEmptyCollection()

            // save it to the account
            signer.save(<-collection, to: Morfi.CollectionStoragePath)

            // create a public capability for the collection
            signer.link<&Morfi.Collection{NonFungibleToken.CollectionPublic, NonFungibleToken.Receiver, MetadataViews.ResolverCollection}>(Morfi.CollectionPublicPath, target: Morfi.CollectionStoragePath)
        }
    }
}
