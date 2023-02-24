import Morfi from "../contracts/Morfi.cdc"
import MetadataViews from "../contracts/standard/MetadataViews.cdc"

pub fun main(Account: Address): [Morfi.NFTMetadata] {
  let collection = getAccount(Account).getCapability(Morfi.CollectionPublicPath)
                      .borrow<&Morfi.Collection{MetadataViews.ResolverCollection}>()!
  let answer: [Morfi.NFTMetadata] = []

  let ids = collection.getIDs()

  for id in ids {
    let resolver = collection.borrowViewResolver(id: id)
    let serialView = resolver.resolveView(Type<MetadataViews.Serial>())! as! MetadataViews.Serial
    answer.append(Morfi.getNFTMetadata(serialView.number)!)
  }

  return answer
}