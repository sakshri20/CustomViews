//
//  ListAndGridWithImages.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/17/26.
//

import SwiftUI
import Combine

struct ImageItem: Identifiable {
    let id = UUID()
    let image: UIImage
}

class ImageViewModel: ObservableObject {
    
    @Published var imageItems: [ImageItem] = []
    
    let urlStrings: [String] = [
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
        "https://picsum.photos/200",
    ]
    
    func getImage() {
        for url in urlStrings {
            if let data = try? Data(contentsOf: URL(string: url)!) {
                imageItems.append(ImageItem(image: UIImage(data: data)!))
            }
        }
    }
}

struct ListAndGridWithImages: View {
    
    @StateObject var viewModel = ImageViewModel()
    
    
    var body: some View {
        // CustomGridView(viewModel: viewModel)
        CustomListView(viewModel: viewModel)
       
    }
}

struct CustomGridView: View {
    
    @ObservedObject var viewModel: ImageViewModel
    @State var selectedImage: ImageItem? = nil
    
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 6),
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 6),
        GridItem(.adaptive(minimum: 100, maximum: 300), spacing: 6)
    ]
    
    var body: some View {
        VStack {
            if selectedImage != nil {
                Image(uiImage: selectedImage!.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 400)
                    .frame(maxWidth: .infinity)
                    .padding(5)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(height: 400)
                    .frame(maxWidth: .infinity)
                    .padding(5)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 6) {
                    ForEach(viewModel.imageItems, content: { item in
                        Button(action: {
                            selectedImage = item
                        }, label: {
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(20)
                                .frame(width:100, height: 100)
                        })
                    })
                }
                .padding()
            }
        }
        .onAppear(perform: {
            viewModel.getImage()
        })
    }
}

struct CustomListView: View {
    @ObservedObject var viewModel: ImageViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1)
            
            List {
                ForEach(viewModel.imageItems, content: { item in
                    HStack(spacing:20) {
                        Image(uiImage: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                        Text("\(item.id.uuidString)")
                    }
                })
            }
            .background(.ultraThickMaterial)
        }
        .task {
            viewModel.getImage()
        }
    }
}

#Preview {
    ListAndGridWithImages()
}
