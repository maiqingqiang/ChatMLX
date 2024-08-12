struct Model: Identifiable {
    let id = UUID()
    let name: String
    let group: String
    var isVisible: Bool
    var isDefault: Bool
}