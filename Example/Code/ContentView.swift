//
//  Copyright 2022 • Sidetrack Tech Limited
//

import SwiftUI
import PictureInPicture

struct ContentView: View {
    @State var isPresentedOne = false
    @State var isPresentedTwo = false
    @State var isPresentedThree = false
    @State var isPresentedFour = false
    
    var body: some View {
        VStack {
            Text("SwiftUI Picture in picture")
                .font(.title)
            
            Button("Launch Basic Example") {
                isPresentedTwo.toggle()
            }
            
            Text("View (Tap on me!)")
                .foregroundColor(.red)
                .fontWeight(.medium)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .pictureInPicture(isPresented: $isPresentedOne)
                .padding(.top)
                .onTapGesture {
                    isPresentedOne.toggle()
                }
            
            Button("Basic Example") { isPresentedThree.toggle() }
                .pictureInPicture(isPresented: $isPresentedThree) {
                    Text("Example Three")
                        .foregroundColor(.red)
                        .padding()
                        .onPictureInPictureSkip { _ in }
                        .onPictureInPicturePlayPause { _ in }
                }
            
            Button("Progress Bar") { isPresentedFour.toggle() }
                .pictureInPicture(isPresented: $isPresentedFour) { LoadingBarView() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pictureInPicture(isPresented: $isPresentedTwo, content: BasicExample.init)
    }
}
