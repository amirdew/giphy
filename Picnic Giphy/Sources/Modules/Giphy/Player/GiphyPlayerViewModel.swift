//
//  GiphyPlayerViewModel.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation
import Combine
import UIKit

class GiphyPlayerViewModel: ObservableObject {
    
    // MARK: Constants
    
    enum Status {
        
        // MARK: Cases
        
        case none
        case downloading
        case failed(Int)
        case schedulingNext(Int)
    }
    
    
    // MARK: Properties
    
    @Published var statusText: String = ""
    @Published var sourceURL: URL? = nil
    let closeButtonTitle: String = "Close"
    var title: String {
        giphy?.title ?? ""
    }
    var giphyAspectRatio: Float {
        Float(giphy?.height ?? 1) / Float(giphy?.width ?? 1)
    }
    
    private var status: Status = .none {
        didSet {
            updateStatusText()
        }
    }
    private let fileRepository: FileRepository
    private let giphyRepository: GiphyRepository
    private var giphy: Giphy?
    private var nextGiphy: Giphy?
    private var cancelableSet: Set<AnyCancellable> = Set()
    private var timer: Timer?
    
    
    // MARK: Lifecycle
    
    init(giphy: Giphy, fileRepository: FileRepository, giphyRepository: GiphyRepository) {
        self.fileRepository = fileRepository
        self.giphyRepository = giphyRepository
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.onTimerPulse()
        }
        self.nextGiphy = giphy
        downloadGiphy(giphy)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    
    // MARK: Private functions
    
    private func downloadGiphy(_ giphy: Giphy) {
        let url = fileRepository.cacheBaseURL.appendingPathComponent("giphy\(giphy.id).mp4")
        status = .downloading
        giphyRepository.downloadGiphy(giphy)
            .mapError { $0 as Error }
            .flatMap {
                self.fileRepository.writeAsync($0, to: url)
            }
            .flatMap {
                self.giphyRepository.fetchRandomGiphy()
            }
            .sink(receiveCompletion: { [weak self] result in
                if case .failure(let error) = result {
                    print(error)
                    self?.status = .failed(5)
                }
            }, receiveValue: { [weak self] nextGiphy in
                self?.scheduleNextGiphy(nextGiphy)
                DispatchQueue.main.async { [weak self] in
                    self?.giphy = giphy
                    self?.sourceURL = url
                }
            })
            .store(in: &cancelableSet)
    }
    
    private func scheduleNextGiphy(_ giphy: Giphy) {
        nextGiphy = giphy
        status = .schedulingNext(10)
    }
    
    private func updateStatusText() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch self.status {
            case .failed(let seconds):
                self.statusText = "Failed to download, retry in \(seconds) sec"
            case .downloading:
                self.statusText = "Downloading"
            case .schedulingNext(let seconds):
                self.statusText = "Next giphy in \(seconds) sec"
            case .none:
                return
            }
        }
    }
    
    private func onTimerPulse() {
        if case .schedulingNext(let seconds) = status {
            if seconds > 1 {
                status = .schedulingNext(seconds - 1)
            } else if let nextGiphy = nextGiphy {
                downloadGiphy(nextGiphy)
            }
        }
        if case .failed(let seconds) = status {
            if seconds > 1 {
                status = .failed(seconds - 1)
            } else if let nextGiphy = nextGiphy {
                downloadGiphy(nextGiphy)
            }
        }
    }
    
}


#if DEBUG
let previewGiphyPlayerViewModel = GiphyPlayerViewModel(
    giphy: previewGiphyGalleryViewModel.items.first!,
    fileRepository: FileRepository(),
    giphyRepository: GiphyRepository(webAPI: WebAPI())
)
#endif
