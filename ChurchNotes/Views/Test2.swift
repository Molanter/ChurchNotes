import SwiftUI

struct Test2: View {
    @State private var multiSelection = Set<UUID>()
    private var books = [
        Book(name: "SwiftUI"),
        Book(name: "Swift"),
        Book(name: "Objective-C"),
        Book(name: "C#"),
        Book(name: "Java"),
        Book(name: "SwiftUI"),
        Book(name: "Swift"),
        Book(name: "Objective-C"),
        Book(name: "C#"),
        Book(name: "Java")
    ]
    var body: some View {
        NavigationView {
            List(books, selection: $multiSelection) {
                Text($0.name)
            }
            .listStyle(.plain)
            .navigationTitle("Books")
            .toolbar { EditButton() }
        }
        Text("\(multiSelection.count) selected")
    }
}

#Preview {
    Test2()
}

struct Book: Identifiable, Hashable {
    let name: String
    let id = UUID()
}
