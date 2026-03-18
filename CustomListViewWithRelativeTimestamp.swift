//
//  CustomListViewWithRelativeTimestamp.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/18/26.
//

import SwiftUI
import Combine

struct ItemModel: Identifiable {
    let id = UUID()
    let text: String
    let createdAt: Date = .now
}

class ListViewModel: ObservableObject {
    
    @Published var items: [ItemModel] = [] {
        didSet {
            // do something
        }
    }
    
    func addItem(text: String) {
        items.append(ItemModel(text: text))
    }
    
}

struct CustomListViewWithRelativeTimestamp: View {
    
    @StateObject private var viewModel = ListViewModel()
    @State var showAddItemSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items, content: { item in
                        customListRowView(item: item)
                })
            }
            .navigationTitle(Text("Relative Timestamp"))
            .toolbar(content: {
                ToolbarItem(
                    placement: .navigationBarTrailing, content: {
                        Button(action: {
                            showAddItemSheet = true
                        }, label: {
                            Image(systemName: "plus")
                        })
                    })
            })
        }
        .sheet(isPresented: $showAddItemSheet, content: {
            AddItemView(viewModel: viewModel)
        })
        
    }
}

struct customListRowView: View {
    
    let item: ItemModel
    
    var body: some View {
        TimelineView(.periodic(from: .now, by: getInterval(from: item.createdAt, now: .now))) { context in
            HStack {
                Text(item.text)
                Spacer()
                Text(getCreatedAtString(from: item.createdAt, now: context.date))
            }
        }
    }
    
    func getCreatedAtString(from date: Date, now: Date) -> String {
        
        let seconds = Int(now.timeIntervalSince(date))
        
        if seconds < 60 {
            return "\(seconds) sec ago"
        } else if seconds < 3600 {
            let mins = seconds / 60
            return "\(mins) min ago"
        } else if seconds < 86400 {
            let hrs = seconds / 3600
            return "\(hrs) hr ago"
        } else {
            let days = seconds / 86400
            return "\(days) hr ago"
        }
    }
    
    func getInterval(from date: Date, now: Date) -> TimeInterval {
        
        let seconds = Int(now.timeIntervalSince(date))
        
        if seconds < 60 {
            return 1
        } else if seconds < 3600 {
            return 60
        } else if seconds < 86400 {
            return 3600
        } else {
            return 86400
        }
    }
}

struct AddItemView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: ListViewModel
    @State private var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .font(.caption)
                    .foregroundColor(.black)
            })
            .frame(width: 25, height: 25)
            
            Spacer()
            
            TextField("type something", text: $text)
                .font(.title)
                .cornerRadius(20)
                .background(Color(.secondarySystemBackground))
            
            Button(action: {
                viewModel.addItem(text: text)
            }, label: {
                Text("Save".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(.blue)
                    .cornerRadius(10)
            })
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    CustomListViewWithRelativeTimestamp()
}
