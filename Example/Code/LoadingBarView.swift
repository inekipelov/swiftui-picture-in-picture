//
//  Copyright 2022 • Sidetrack Tech Limited
//

import SwiftUI
import PictureInPicture

struct LoadingBarView: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var progress: Double = 0
    
    var body: some View {
        Text("Loading...")
            .padding()
            .foregroundColor(.red)
            .pictureInPicture(progress: $progress)
            .onReceive(timer) { _ in
                let newProgress = progress + 0.05
                
                if newProgress > 1 {
                    progress = 0
                } else {
                    progress = newProgress
                }
            }
    }
    
}
