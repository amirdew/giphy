//
//  GiphyGalleryRow.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//
import SwiftUI

struct GiphyGalleryViewRow: View {
    
    // MARK: Properties
    
    @ObservedObject
    var imageLoader: ImageLoader<GiphyRepository>
    
    var giphy: Giphy
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.clear)
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
        .frame(maxHeight: 100)
        .clipped()
    }
}


extension GiphyGalleryViewRow {
    
    var uiImage: UIImage {
        imageLoader.image(for: giphy, placeHolder: UIImage())
    }
}


struct GiphyGalleryViewRow_Previews: PreviewProvider {
    static var previews: some View {
        GiphyGalleryViewRow(imageLoader: previewGiphyGalleryViewModel.getNewImageLoader(),
                            giphy: previewGiphyGalleryViewModel.items.first!)
    }
}
