//
//  TextTagCollectionView+SwiftUI.swift
//  TTGTags
//
//  SwiftUI integration via UIViewRepresentable.

#if canImport(SwiftUI)
import SwiftUI
import UIKit

/// SwiftUI wrapper for `TextTagCollectionView`.
///
/// Usage:
/// ```swift
/// TagCloudView(tags: ["Swift", "Kotlin", "Dart"]) { tag in
///     // configure style, etc.
/// }
/// ```
@available(iOS 16.0, *)
public struct TagCloudView: UIViewRepresentable {

    public typealias TagConfigurator = (TextTag) -> Void
    public typealias TagTapHandler = (_ text: String, _ index: Int, _ selected: Bool) -> Void
    public typealias ContentSizeHandler = (_ contentSize: CGSize) -> Void

    private let texts: [String]
    private let scrollDirection: TagCollectionScrollDirection
    private let alignment: TagCollectionAlignment
    private let numberOfLines: Int
    private let horizontalSpacing: CGFloat
    private let verticalSpacing: CGFloat
    private let contentInset: UIEdgeInsets
    private let configurator: TagConfigurator?
    private let onTapTag: TagTapHandler?
    private let onUpdateContentSize: ContentSizeHandler?

    /// Creates a `TagCloudView` that displays the given strings as tags.
    ///
    /// - Parameters:
    ///   - tags: The text strings to display.
    ///   - scrollDirection: Scroll direction. Defaults to `.vertical`.
    ///   - alignment: Tag alignment. Defaults to `.left`.
    ///   - numberOfLines: Maximum number of lines (0 = unlimited). Defaults to `0`.
    ///   - horizontalSpacing: Horizontal spacing between tags. Defaults to `8`.
    ///   - verticalSpacing: Vertical spacing between lines. Defaults to `8`.
    ///   - contentInset: Content padding. Defaults to 8pt on each side.
    ///   - configurator: Optional closure to customize each `TextTag` (style, selection, etc.).
    ///   - onTapTag: Optional callback fired after a tag is tapped and selection changes.
    ///   - onUpdateContentSize: Optional callback fired when the wrapped tag view updates content size.
    public init(
        tags: [String],
        scrollDirection: TagCollectionScrollDirection = .vertical,
        alignment: TagCollectionAlignment = .left,
        numberOfLines: Int = 0,
        horizontalSpacing: CGFloat = 8,
        verticalSpacing: CGFloat = 8,
        contentInset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        configurator: TagConfigurator? = nil,
        onTapTag: TagTapHandler? = nil,
        onUpdateContentSize: ContentSizeHandler? = nil
    ) {
        self.texts = tags
        self.scrollDirection = scrollDirection
        self.alignment = alignment
        self.numberOfLines = numberOfLines
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.contentInset = contentInset
        self.configurator = configurator
        self.onTapTag = onTapTag
        self.onUpdateContentSize = onUpdateContentSize
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onTapTag: onTapTag, onUpdateContentSize: onUpdateContentSize)
    }

    public func makeUIView(context: Context) -> TextTagCollectionView {
        let view = TextTagCollectionView()
        view.delegate = context.coordinator
        view.scrollDirection = scrollDirection
        view.alignment = alignment
        view.numberOfLines = numberOfLines
        view.horizontalSpacing = horizontalSpacing
        view.verticalSpacing = verticalSpacing
        view.contentInset = contentInset
        return view
    }

    public func updateUIView(_ uiView: TextTagCollectionView, context: Context) {
        context.coordinator.onTapTag = onTapTag
        context.coordinator.onUpdateContentSize = onUpdateContentSize
        uiView.delegate = context.coordinator
        uiView.scrollDirection = scrollDirection
        uiView.alignment = alignment
        uiView.numberOfLines = numberOfLines
        uiView.horizontalSpacing = horizontalSpacing
        uiView.verticalSpacing = verticalSpacing
        uiView.contentInset = contentInset
        uiView.removeAllTags()

        let tags: [TextTag] = texts.map { text in
            let content = TextTagStringContent(text: text)
            let style = TextTagStyle()
            let tag = TextTag(content: content, style: style)
            configurator?(tag)
            return tag
        }

        uiView.add(tags: tags)
        uiView.reload()
    }

    public final class Coordinator: NSObject, TextTagCollectionViewDelegate {
        var onTapTag: TagTapHandler?
        var onUpdateContentSize: ContentSizeHandler?

        init(onTapTag: TagTapHandler?, onUpdateContentSize: ContentSizeHandler?) {
            self.onTapTag = onTapTag
            self.onUpdateContentSize = onUpdateContentSize
        }

        public func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView,
                                          didTapTag tag: TextTag,
                                          at index: Int) {
            let text = tag.content.getContentAttributedString().string
            onTapTag?(text, index, tag.selected)
        }

        public func textTagCollectionView(_ textTagCollectionView: TextTagCollectionView,
                                          updateContentSize contentSize: CGSize) {
            DispatchQueue.main.async { [weak self] in
                self?.onUpdateContentSize?(contentSize)
            }
        }
    }
}
#endif
