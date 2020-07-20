
import Foundation

enum DifficultySetting {
    
    case easy
    case standard
    case hard

    var baseProductivityLength: Int {
        switch self {
        case .easy:
            return 1200
        case .standard:
            return 1500
        case .hard:
            return 3300
        }
    }
    
    var baseBreakLength: Int {
        switch self {
        case .easy:
            return 600
        case .standard:
            return 300
        case .hard:
            return 300
        }
    }
    
}
