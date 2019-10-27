//
//  GiphyPlayerView.swift
//  Picnic Giphy
//
//  Created by Amir on 26/10/2019.
//  Copyright © 2019 Amir. All rights reserved.
//

import SwiftUI

protocol GiphyPlayerViewDelegate: class {
    func onCloseTouch()
}


struct GiphyPlayerView: View {
    
    // MARK: Properties
    
    @ObservedObject
    var viewModel: GiphyPlayerViewModel
    
    weak var delegate: GiphyPlayerViewDelegate?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                AVPlayerView()
                    .frame(width: geometry.size.width * 0.9,
                           height: geometry.size.width * 0.8)
                    .cornerRadius(20)
                Button(action: {
                    self.delegate?.onCloseTouch()
                }, label: {
                    Text(self.viewModel.closeButtonTitle)
                })
            }
        }
    }
}


struct GiphyPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        GiphyPlayerView(viewModel: GiphyPlayerViewModel())
    }
}
