//
//  SearchableList.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/16/26.
//

import SwiftUI
import Combine

struct ListItem: Identifiable {
    let id: String
    let name: String
    let age: Int
}

class SearchableListViewModel: ObservableObject {
    
    @Published var listItems: [ListItem] = []
    
    func getListItems() {
        listItems = [
            ListItem(id: UUID().uuidString, name: "Sakshi", age: 34),
            ListItem(id: UUID().uuidString, name: "James", age: 29),
            ListItem(id: UUID().uuidString, name: "Tom", age: 89),
            ListItem(id: UUID().uuidString, name: "Jerry", age: 24),
            ListItem(id: UUID().uuidString, name: "Kely", age: 17),
            ListItem(id: UUID().uuidString, name: "Benny", age: 21),
            ListItem(id: UUID().uuidString, name: "Ruth", age: 90)
        ]
    }
    
    func sortListItemsByAge() {
        listItems = listItems.sorted(by: {$0.age < $1.age})
    }
}

struct SearchableList: View {
    
    @StateObject private var viewModel = SearchableListViewModel()
    @State private var searchString: String = ""
    private var filteredItems: [ListItem] {
        return searchString.isEmpty ? viewModel.listItems : viewModel.listItems.filter({$0.name.localizedCaseInsensitiveContains(searchString)})
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredItems, content: { item in
                    ListItemRow(item: item)
                })
            }
            .searchable(text: $searchString)
            .navigationTitle(Text("Searchable List"))
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing, content: {
                    customeToolBar
                })
            })
        }
        .task {
            viewModel.getListItems()
        }
    }
}

extension SearchableList {
    
    private var customeToolBar: some View {
        Button(action: {
            viewModel.sortListItemsByAge()
        }, label: {
            Image(systemName: "arrow.up.arrow.down")
        })
    }
}

struct ListItemRow: View {
    
    @State var item: ListItem
    
    var body: some View {
        HStack {
            Label(item.name, systemImage: "person.fill")
            Spacer()
            Text("\(item.age)")
        }
        .frame(height: 55)
        .padding(5)
    }
}

#Preview {
    SearchableList()
}
