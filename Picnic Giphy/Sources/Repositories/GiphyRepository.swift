//
//  GiphyRepository.swift
//  Picnic Giphy
//
//  Created by Amir on 27/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation
import Combine

class GiphyRepository {
    
    // MARK: Properties
    
    var giphyList: [Giphy] {
        giphyListSubject.value
    }
    
    var giphyListPublisher: AnyPublisher<[Giphy], Never> {
        giphyListSubject.eraseToAnyPublisher()
    }
    
    private let webAPI: WebAPI
    private let giphyListSubject = CurrentValueSubject<[Giphy], Never>([])
    private let pageSize = 25
    private var offset = 0
    private var totalCount: Int?
    private var fetching = false
    private var cancelableSet: Set<AnyCancellable> = Set()
    
    
    // MARK: Lifecycle
    
    init(webAPI: WebAPI) {
        self.webAPI = webAPI
    }
    
    deinit {
        cancelableSet.forEach {
            $0.cancel()
        }
    }
    
    
    // MARK: Public functions
    
    func fetchMoreGiphy() {
        guard !fetching, offset < totalCount ?? 1 else {
            return
        }
        fetching = true
        let publisher: AnyPublisher<WebAPI.GiphyList, Error> = webAPI.request(endPoint: .trending(pageSize, offset))
        publisher
            .sink(receiveCompletion: { [weak self] result in
                self?.fetching = false
                if case .failure(let error) = result {
                    print("Failed to fetch giphy trending list: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] in
                self?.processAPIResponse($0)
            })
            .store(in: &cancelableSet)
    }
    
    
    // MARK: Private functions
    
    private func processAPIResponse(_ response: WebAPI.GiphyList) {
        var list = giphyListSubject.value
        offset = response.pagination.count + response.pagination.offset
        totalCount = response.pagination.totalCount
        let newItems = response.data.compactMap { item -> Giphy? in
            guard let url = URL(string: item.images.preview.url) else {
                return nil
            }
            return Giphy(title: item.title, previewImageURL: url)
        }
        list.append(contentsOf: newItems)
        giphyListSubject.send(list)
    }
    
}


extension GiphyRepository: ImageDownloader {
    
    func downloadImage(for giphy: Giphy) -> AnyPublisher<Data, URLError> {
        webAPI.downloadPublicData(url: giphy.previewImageURL)
    }
    
}

