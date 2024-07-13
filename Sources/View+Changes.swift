//
//  Copyright 2022 • Sidetrack Tech Limited
//

import SwiftUI

public extension View {
    /// When the user uses the play/pause button inside the picture-in-picture window, the provided closure is called.
    ///
    /// The `Bool` is true if playing, else paused.
    @warn_unqualified_access
    func onPictureInPicturePlayPause(_ playPause: @escaping (Bool) -> Void) -> some View {
        modifier(PictureInPicturePlayPauseModifier(closure: playPause))
    }
    
    /// When the user uses the skip forward/backward button inside the picture-in-picture window, the provided closure is called.
    ///
    /// The `Bool` is true if forward, else backwards.
    @warn_unqualified_access
    func onPictureInPictureSkip(_ skip: @escaping (Bool) -> Void) -> some View {
        modifier(PictureInPictureSkipModifier(closure: skip))
    }
    
    /// When picture-in-picture is started, the provided closure is called.
    @warn_unqualified_access
    func onPictureInPictureStart(_ start: @escaping () -> Void) -> some View {
        modifier(PictureInPictureStatusModifier(closure: { newValue in
            if newValue {
                start()
            }
        }))
    }
    
    /// When picture-in-picture is stopped, the provided closure is called.
    @warn_unqualified_access
    func onPictureInPictureStop(_ stop: @escaping () -> Void) -> some View {
        modifier(PictureInPictureStatusModifier(closure: { newValue in
            if newValue == false {
                stop()
            }
        }))
    }
    
    /// When the render size of the picture-in-picture window is changed, the provided closure is called.
    @warn_unqualified_access
    func onPictureInPictureSizeChanged(_ sizeChanged: @escaping (CGSize) -> Void) -> some View {
        modifier(PictureInPictureRenderSizeModifier(closure: sizeChanged))
    }
    
    /// When the application is moved to the foreground, and if picture-in-picture is active, stop it.
    @warn_unqualified_access
    func pictureInPictureHideOnForeground() -> some View {
        modifier(PictureInPictureForegroundModifier())
    }
    
    /// When the application is moved to the background, activate picture-in-picture.
    @warn_unqualified_access
    func pictureInPictureShowOnBackground() -> some View {
        modifier(PictureInPictureBackgroundModifier())
    }
    
    /// Provides a binding to a double whose value is used to update the progress bar in the picture-in-picture window.
    @warn_unqualified_access
    func pictureInPicture(progress: Binding<Double>) -> some View {
        modifier(PictureInPictureProgressModifier(progress: progress))
    }
}

internal struct PictureInPicturePlayPauseModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    let closure: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                controller.isPlayPauseEnabled = true
            }
            .onChange(of: controller.isPlaying) { newValue in
                closure(newValue)
            }
    }
}

internal struct PictureInPictureRenderSizeModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    let closure: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: controller.renderSize) { newValue in
                closure(newValue)
            }
    }
}

internal struct PictureInPictureStatusModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    let closure: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: controller.enabled) { newValue in
                closure(newValue)
            }
    }
}

internal struct PictureInPictureSkipModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    let closure: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content
            .task {
                controller.onSkip = { value in
                    closure(value > 0) // isForward
                }
            }
    }
}

internal struct PictureInPictureBackgroundModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    @Environment(\.scenePhase) var scenePhase
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .background {
                    controller.isPlaying = true
                }
            }
    }
}

internal struct PictureInPictureForegroundModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    @Environment(\.scenePhase) var scenePhase
    
    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    controller.isPlaying = false
                }
            }
    }
}

internal struct PictureInPictureProgressModifier: ViewModifier {
    @EnvironmentObject var controller: PictureInPictureEnvironment
    @Binding var progress: Double
    
    func body(content: Content) -> some View {
        content
            .onChange(of: progress) { newProgress in
                assert(newProgress >= 0 && newProgress <= 1, "progress value must be between 0 and 1")
                controller.progress = newProgress.clamped(to: 0...1)
            }
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
