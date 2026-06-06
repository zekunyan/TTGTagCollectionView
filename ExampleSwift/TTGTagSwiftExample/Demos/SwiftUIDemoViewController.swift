//
//  SwiftUIDemoViewController.swift
//  TTGTagSwiftExample
//
//  Demo 4: SwiftUI integration via TagCloudView (UIViewRepresentable).
//  Hosts a SwiftUI view inside UIKit using UIHostingController.

import UIKit
import SwiftUI
import TTGTags

class SwiftUIDemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let swiftUIView = SwiftUIDemoView()
        let hostingController = UIHostingController(rootView: swiftUIView)

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

// MARK: - SwiftUI View

import SwiftUI

struct SwiftUIDemoView: View {
    @State private var extraTags: [String] = []

    private let baseTags = ["Swift", "Kotlin", "Dart", "Rust", "Go", "Python", "TypeScript"]

    var allTags: [String] { baseTags + extraTags }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Section 1: Basic tag cloud
                VStack(alignment: .leading, spacing: 8) {
                    Text("Programming Languages")
                        .font(.headline)

                    TagCloudView(tags: allTags) { tag in
                        if let content = tag.content as? TextTagStringContent {
                            content.textFont = .systemFont(ofSize: 14, weight: .medium)
                            content.textColor = .white
                        }
                        tag.style.backgroundColor = .systemBlue
                        tag.style.cornerRadius = 14
                        tag.style.extraSpace = CGSize(width: 12, height: 6)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Section 2: Different alignment
                VStack(alignment: .leading, spacing: 8) {
                    Text("Center Aligned")
                        .font(.headline)

                    TagCloudView(
                        tags: ["One", "Two", "Three"],
                        alignment: .center
                    ) { tag in
                        if let content = tag.content as? TextTagStringContent {
                            content.textFont = .systemFont(ofSize: 14, weight: .medium)
                            content.textColor = .white
                        }
                        tag.style.backgroundColor = .systemGreen
                        tag.style.cornerRadius = 14
                        tag.style.extraSpace = CGSize(width: 12, height: 6)
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)

                // Section 3: Add tag dynamically
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dynamic (\(allTags.count) tags)")
                        .font(.headline)

                    Button("Add Random Tag") {
                        let randomTag = "Tag \(Int.random(in: 100...999))"
                        extraTags.append(randomTag)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)

                // Section 4: Horizontal scroll
                VStack(alignment: .leading, spacing: 8) {
                    Text("Horizontal Scroll")
                        .font(.headline)

                    TagCloudView(
                        tags: allTags,
                        scrollDirection: .horizontal,
                        numberOfLines: 1
                    ) { tag in
                        if let content = tag.content as? TextTagStringContent {
                            content.textFont = .systemFont(ofSize: 13, weight: .medium)
                            content.textColor = .white
                        }
                        tag.style.backgroundColor = .systemOrange
                        tag.style.cornerRadius = 12
                        tag.style.extraSpace = CGSize(width: 10, height: 4)
                    }
                    .frame(height: 44)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
}
