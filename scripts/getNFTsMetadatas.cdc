import Morfi from "../contracts/Morfi.cdc"

pub fun main(): {UInt64: Morfi.NFTMetadata} {
  return Morfi.getNFTMetadatas()
}