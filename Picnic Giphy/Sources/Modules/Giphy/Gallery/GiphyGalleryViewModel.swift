//
//  GiphyGalleryViewModel.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation
import Combine

class GiphyGalleryViewModel: ObservableObject {
    
    // MARK: Properties
    
    @Published var items: [Giphy] = []
    
    private let fileRepository: FileRepository
    private let giphyRepository: GiphyRepository
    private var cancelableSet: Set<AnyCancellable> = Set()
    
    init(items: [Giphy] = [], fileRepository: FileRepository, giphyRepository: GiphyRepository) {
        self.items = items
        self.fileRepository = fileRepository
        self.giphyRepository = giphyRepository
        sinkToGiphyList()
        giphyRepository.fetchMoreGiphy()
    }
    
    
    // MARK: Public functions
    
    func getNewImageLoader() -> ImageLoader<GiphyRepository> {
        ImageLoader(downloader: giphyRepository, fileRepository: fileRepository)
    }
    
    func fetchNextPageIfNeeded(_ giphy: Giphy) {
        if items.firstIndex(where: { $0.id == giphy.id }) == items.count - 1 {
            giphyRepository.fetchMoreGiphy()
        }
    }
    
    
    // MARK: Private functions
    
    func sinkToGiphyList() {
        giphyRepository.giphyListPublisher
            .sink { newItems in
                DispatchQueue.main.async { [weak self] in
                    self?.items = newItems
                }
            }
            .store(in: &cancelableSet)
    }
    
}


#if DEBUG
let previewGiphyGalleryViewModel = GiphyGalleryViewModel(
    items: [
        Giphy(title: "first", previewImageURL: URL(string: "https://media.giphy.com/media/l4dqF0Aw5S8xXKHP5j/giphy.gif")!),
        Giphy(title: "first", previewImageURL: URL(string: "https://media.giphy.com/media/YnBntKOgnUSBkV7bQH/giphy.gif")!),
        Giphy(title: "first", previewImageURL: URL(string: "https://media.giphy.com/media/Kenaq5YK78qy5flMCf/giphy.gif")!),
        Giphy(title: "first", previewImageURL: URL(string: "https://media.giphy.com/media/S6qkS0ETvel6EZat45/giphy.gif")!),
        Giphy(title: "first", previewImageURL: URL(string: "https://media.giphy.com/media/KxseCTOPVykYvG2V4R/giphy.gif")!)
    ],
    fileRepository: FileRepository(),
    giphyRepository: GiphyRepository(webAPI: WebAPI())
)
#endif
