
import Foundation

extension String {
    func localize(from dictionaryName: LocalizableScreens) -> String {
        let localizedString = NSLocalizedString(self, tableName: dictionaryName.rawValue, bundle: Bundle.main, value: "", comment: "")
        return localizedString
    }
}
