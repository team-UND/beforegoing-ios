struct NonceResponseDTO: Decodable {
    let nonce: String
}

extension NonceResponseDTO {
    func toEntity() -> NonceEntity {
        return .init(nonce: nonce)
    }
}
