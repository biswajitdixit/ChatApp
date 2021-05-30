import Foundation

enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    case notification
    case help
    
    var description:String {
        switch self {
        case .accountInfo: return "Account"
        case .settings: return "Settings"
        case .notification: return "Notifications"
        case .help: return "Help"
        }
    }
    
    var iconImageName: String {
        switch self {
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        case .notification: return "bell"
        case .help:return "questionmark.circle"
        }
    }
    
}
