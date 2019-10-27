//
//  AVPlayerView.swift
//  Picnic Giphy
//
//  Created by Amir on 27/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import Foundation
import SwiftUI
import AVKit

struct AVPlayerView: UIViewControllerRepresentable {

    typealias UIViewControllerType = AVPlayerViewController


    func makeUIViewController(context: UIViewControllerRepresentableContext<AVPlayerView>) -> AVPlayerView.UIViewControllerType {
        let vc = AVPlayerViewController()
        vc.allowsPictureInPicturePlayback = false
        vc.showsPlaybackControls = false
        return vc
    }

    func updateUIViewController(_ uiViewController: AVPlayerView.UIViewControllerType, context: UIViewControllerRepresentableContext<AVPlayerView>) {
        //
    }
}
