import Morfi from "../contracts/Morfi.cdc"

pub fun main(MetadataId: UInt64): UInt64? {
  return Morfi.getNFTMetadata(MetadataId)?.minted
}