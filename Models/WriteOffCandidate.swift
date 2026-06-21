import Foundation

struct WriteOffCandidate: Identifiable {
    let id = UUID()
    let name: String
    let type: CandidateType
}

enum CandidateType {
    case product
    case semi
}
