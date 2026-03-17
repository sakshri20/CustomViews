//
//  AsyncImageExample.swift
//  CustomViews
//
//  Created by Sakshi Shrivastava on 3/10/26.
//

import SwiftUI

struct AsyncImageExample: View {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    var body: some View {
        AsyncImage(url: url) { result in
            
            switch result {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(_):
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            case .empty:
                ProgressView()
            @unknown default:
                Color.clear
            }
        }
        .frame(width: 56, height: 56)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    AsyncImageExample()
}
