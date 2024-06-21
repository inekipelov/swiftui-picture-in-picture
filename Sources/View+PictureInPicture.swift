//
//  Copyright 2022 • Sidetrack Tech Limited
//

import SwiftUI

public extension View {
    
    /// Creates a Picture in Picture experience when given a SwiftUI view. This allows a view of your application to be presented over the top of the application
    /// window and even when your application is in the background.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a boolean which determines when the Picture in Picture controller should be presented.
    ///   - content: A closure which returns the view you wish to present in the Picture in Picture controller.
    @warn_unqualified_access
    func pictureInPicture<ContentView: View>(
        isPresented: Binding<Bool>,
        content: @escaping () -> ContentView
    ) -> some View {
        modifier(PictureInPictureModifier(
            isPresented: isPresented,
            pipContent: content,
            offscreenRendering: true
        ))
    }
    
    /// Creates a Picture in Picture experience using the current view. This allows the view to be presented over the top of the application window and even when
    /// your application is in the background.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a boolean which determines when the Picture in Picture controller should be presented.
    @warn_unqualified_access
    func pictureInPicture(
        isPresented: Binding<Bool>
    ) -> some View {
        modifier(PictureInPictureModifier(
            isPresented: isPresented,
            pipContent: { self },
            offscreenRendering: false
        ))
    }
    
}

/// Makes the picture-in-picture view modifier available to Xcode's library allowing for improved auto-complete and discoverability.
///
/// Reference: https://useyourloaf.com/blog/adding-views-and-modifiers-to-the-xcode-library/
struct PictureInPictureLibrary: LibraryContentProvider {
    @State var isPresented: Bool = false
    
    @LibraryContentBuilder
    func modifiers(base: any View) -> [LibraryItem] {
        LibraryItem(base.pictureInPicture(isPresented: $isPresented), title: "PictureInPicture Embedded View")
        LibraryItem(base.pictureInPicture(isPresented: $isPresented) { Text("Hello, world!") }, title: "PictureInPicture External View")
    }
}
