import Foundation

// MARK: - Translations

func getTranslation(key: String) -> String {
    String(localized: String.LocalizationValue(key))
}
