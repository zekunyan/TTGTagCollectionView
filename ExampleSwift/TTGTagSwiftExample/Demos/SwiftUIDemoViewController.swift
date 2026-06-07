//
//  SwiftUIDemoViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import SwiftUI
import TTGTags

class SwiftUIDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)

        let hostingController = UIHostingController(rootView: SwiftUIDemoView())
        hostingController.view.backgroundColor = .clear

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        hostingController.didMove(toParent: self)
    }
}

struct SwiftUIDemoView: View {
    @State private var extraTags: [String] = []
    @State private var selectedTags: Set<String> = ["Swift"]
    @State private var lastTappedText = "Tap a tag to update selection."
    @State private var flowHeight: CGFloat = 150
    @State private var centerHeight: CGFloat = 74

    private let baseTags = [
        "Swift", "UIKit", "SwiftUI", "Objective-C",
        "Auto Layout", "Accessibility", "Testing", "Animation",
        "Intrinsic Size", "UIViewRepresentable"
    ]

    private var allTags: [String] {
        baseTags + extraTags
    }

    var body: some View {
        GeometryReader { geometry in
            let contentWidth = max(0, geometry.size.width - 32)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header

                    tagSection(title: "Flow layout", width: contentWidth, contentHeight: flowHeight) {
                        TagCloudView(
                            tags: allTags,
                            configurator: configureBlueTag,
                            onTapTag: handleTap,
                            onUpdateContentSize: { flowHeight = max(54, ceil($0.height)) }
                        )
                    }

                    tagSection(title: "Center aligned", width: contentWidth, contentHeight: centerHeight) {
                        TagCloudView(
                            tags: ["One", "Two", "Three", "Four"],
                            alignment: .center,
                            configurator: configureGreenTag,
                            onTapTag: handleTap,
                            onUpdateContentSize: { centerHeight = max(54, ceil($0.height)) }
                        )
                    }

                    selectionSummary
                    addButton

                    tagSection(title: "Horizontal scroll", width: contentWidth, contentHeight: 54) {
                        TagCloudView(
                            tags: allTags,
                            scrollDirection: .horizontal,
                            numberOfLines: 1,
                            configurator: configureOrangeTag,
                            onTapTag: handleTap
                        )
                    }
                }
                .frame(width: contentWidth, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .background(Color(.systemBackground))
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("SwiftUI integration")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.primary)
            Text("TagCloudView exposes TTGTagCollectionView in SwiftUI. The demo constrains every embedded UIKit tag view to the available screen width.")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var addButton: some View {
        Button {
            let newTag = "Tag \(Int.random(in: 100...999))"
            extraTags.append(newTag)
            lastTappedText = "Added \(newTag)"
        } label: {
            Label("Add random tag", systemImage: "plus")
                .font(.system(size: 15, weight: .semibold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }

    private var selectionSummary: some View {
        Text(lastTappedText)
            .font(.system(size: 13))
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }

    private func tagSection<Content: View>(
        title: String,
        width: CGFloat,
        contentHeight: CGFloat,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.secondary)

            content()
                .frame(width: max(0, width - 20), height: contentHeight, alignment: .leading)
                .padding(10)
                .frame(width: width, alignment: .leading)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .clipped()
        }
        .frame(width: width, alignment: .leading)
    }

    private func configureBlueTag(_ tag: TextTag) {
        configure(tag, color: .systemBlue, fontSize: 14)
    }

    private func configureGreenTag(_ tag: TextTag) {
        configure(tag, color: .systemGreen, fontSize: 14)
    }

    private func configureOrangeTag(_ tag: TextTag) {
        configure(tag, color: .systemOrange, fontSize: 13)
    }

    private func configure(_ tag: TextTag, color: UIColor, fontSize: CGFloat) {
        let text = tag.content.getContentAttributedString().string

        if let content = tag.content as? TextTagStringContent {
            content.textFont = .systemFont(ofSize: fontSize, weight: .medium)
            content.textColor = .white
        }

        tag.style.backgroundColor = color
        tag.style.cornerRadius = 14
        tag.style.extraSpace = CGSize(width: 12, height: 6)
        tag.style.borderWidth = 0
        tag.style.shadowOpacity = 0

        let selectedStyle = TextTagStyle()
        selectedStyle.backgroundColor = .systemIndigo
        selectedStyle.cornerRadius = 14
        selectedStyle.extraSpace = CGSize(width: 12, height: 6)
        selectedStyle.borderWidth = 0
        selectedStyle.shadowOpacity = 0
        tag.selectedStyle = selectedStyle
        tag.selected = selectedTags.contains(text)
    }

    private func handleTap(_ text: String, _ index: Int, _ selected: Bool) {
        if selected {
            selectedTags.insert(text)
        } else {
            selectedTags.remove(text)
        }
        lastTappedText = "\(selected ? "Selected" : "Deselected") \(text) at index \(index)"
    }
}
