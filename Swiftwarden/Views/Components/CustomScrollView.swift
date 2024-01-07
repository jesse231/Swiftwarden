//
//  CustomScrollView.swift
//  Swiftwarden
//
//  Created by Jesse Seeligsohn on 2023-07-31.
//

import SwiftUI


class CustomScroll: NSScrollView {
    override func scrollWheel(with event: NSEvent) {
        // Disable scrolling by not passing the event to the superclass.
        // This effectively blocks the scroll view from scrolling.
        // To enable scrolling again, just remove this override or add
        // a condition to decide when to pass the event through.
    }
}


// MARK: - ScrollView
/// A `SwiftUI Scrollview that makes the toolbar nice and pretty
public struct CustomScrollView<Content>: NSViewRepresentable where Content: View {
    private var content: Content
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public typealias NSViewType = NSScrollView

    public func makeNSView(context: NSViewRepresentableContext<CustomScrollView>) -> NSScrollView {
        let view = CustomScroll(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false

        
        view.autohidesScrollers = true
        view.verticalScroller?.alphaValue = 0
        view.horizontalScroller?.alphaValue = 0

        let document = NSHostingView(rootView: self.observingContent(in: view))
        
        let hostingController = NSHostingController(rootView: self.observingContent(in: view))
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.width, .height]
        
        document.translatesAutoresizingMaskIntoConstraints = false

        view.documentView = hostingController.view
                
        return view
    }
    
    public func updateNSView(_ view: NSScrollView, context: NSViewRepresentableContext<CustomScrollView>) {
        guard let document = view.documentView as? NSHostingView<AnyView> else {
            return
        }
        document.rootView = self.observingContent(in: view)
    }

    private func observingContent(in view: NSScrollView) -> AnyView {
        return AnyView(content
                .coordinateSpace(name: ENCLOSING_SCROLLVIEW)
            )
    }
}

// MARK: - Constants
private let ENCLOSING_SCROLLVIEW = "enclosingScrollView"
