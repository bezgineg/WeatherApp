import Foundation

protocol StorageService {
    var isOnboardingCompleteBoolKey: Bool { get set }
    var isTrackingBoolKey: Bool { get set }
    var isCelsiusChosenBoolKey: Bool { get set }
    var isKmChosenBoolKey: Bool { get set }
    var is24TimeFormalChosenBoolKey: Bool { get set }
    var isNotifyBoolKey: Bool { get set }
    var isCityAdded: Bool { get set }
    var isFirstAppearance: Bool { get set }
    var isLocationDisabled: Bool { get set }
}

class UserDefaultStorage: StorageService {
    private enum Keys: String {
        case isOnboardingCompleteBoolKey
        case isTrackingBoolKey
        case isCelsiusChosenBoolKey
        case isKmChosenBoolKey
        case is24TimeFormalChosenBoolKey
        case isNotifyBoolKey
        case isCityAdded
        case isFirstAppearance
        case isLocationDisabled
    }
    
    static let shared = UserDefaultStorage()
    
    private let defaults = UserDefaults.standard
    
    var isOnboardingCompleteBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.isOnboardingCompleteBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isOnboardingCompleteBoolKey.rawValue)
        }
    }
    
    var isTrackingBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.isTrackingBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isTrackingBoolKey.rawValue)
        }
    }
    var isCelsiusChosenBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.isCelsiusChosenBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isCelsiusChosenBoolKey.rawValue)
        }
    }

    var isKmChosenBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.isKmChosenBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isKmChosenBoolKey.rawValue)
        }
    }
    
    var is24TimeFormalChosenBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.is24TimeFormalChosenBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.is24TimeFormalChosenBoolKey.rawValue)
        }
    }

    var isNotifyBoolKey: Bool {
        get {
            return defaults.bool(forKey: Keys.isNotifyBoolKey.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isNotifyBoolKey.rawValue)
        }
    }

    var isCityAdded: Bool {
        get {
            return defaults.bool(forKey: Keys.isCityAdded.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isCityAdded.rawValue)
        }
    }

    var isFirstAppearance: Bool {
        get {
            return defaults.bool(forKey: Keys.isFirstAppearance.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isFirstAppearance.rawValue)
        }
    }
    
    var isLocationDisabled: Bool {
        get {
            return defaults.bool(forKey: Keys.isLocationDisabled.rawValue)
        }
        set {
            defaults.setValue(newValue, forKey: Keys.isLocationDisabled.rawValue)
        }
    }
}

