//
//  ContentView.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/10/26.
//

import SwiftUI

struct Contact: Identifiable {
    let id: String
    let name: String
}

struct ContentView: View {
    
    @State var query: String = ""
    var contacts: [Contact] = [
        Contact(id: UUID().uuidString, name: "Amy"),
        Contact(id: UUID().uuidString, name: "Dewashish"),
        Contact(id: UUID().uuidString, name: "Aanya"),
        Contact(id: UUID().uuidString, name: "Shreya"),
        Contact(id: UUID().uuidString, name: "Yash")
    ]
    var filtered: [Contact] {
        return query.isEmpty ? contacts : contacts.filter({$0.name.localizedCaseInsensitiveContains(query)})
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filtered, content: { item in
                    Text(item.name)
                })
            }
            .searchable(text: $query)
            .overlay {
                if filtered.isEmpty { ContentUnavailableView.search }
            }
        }
    }
}

#Preview {
    ContentView()
}
