//
//  PullRefreshTagsViewController.swift
//  TTGTagSwiftExample
//

import UIKit
import TTGTags

class PullRefreshTagsViewController: UIViewController {

    private let tagView = TextTagCollectionView()
    private var loadMoreObserver: NSKeyValueObservation?
    private var isLoadingMore = false
    private var batchIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        DemoUI.applyScreenBackground(view)
        setupSubviews()
        configureRefresh()
        replaceTags()
    }

    private func setupSubviews() {
        let titleLabel = DemoUI.titleLabel("Pull to refresh")
        let descriptionLabel = DemoUI.descriptionLabel("Uses UIRefreshControl with TTGTextTagCollectionView's internal scroll view. Pull down to replace tags; scroll near the bottom to append another batch.")
        DemoUI.styleTagSurface(tagView)
        tagView.alignment = .fillByExpandingWidth
        tagView.scrollView.alwaysBounceVertical = true
        tagView.scrollDirection = .vertical
        tagView.horizontalSpacing = 8
        tagView.verticalSpacing = 8
        tagView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        [titleLabel, descriptionLabel, tagView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),

            tagView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 18),
            tagView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tagView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tagView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func configureRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        tagView.scrollView.refreshControl = refreshControl

        loadMoreObserver = tagView.scrollView.observe(\.contentOffset, options: [.new]) { [weak self] scrollView, _ in
            self?.loadMoreIfNeeded(scrollView)
        }
    }

    @objc private func refreshTriggered() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.replaceTags()
            self?.tagView.scrollView.refreshControl?.endRefreshing()
        }
    }

    private func loadMoreIfNeeded(_ scrollView: UIScrollView) {
        guard !isLoadingMore, scrollView.contentSize.height > scrollView.bounds.height else { return }
        let threshold = scrollView.contentSize.height - scrollView.bounds.height - 80
        guard scrollView.contentOffset.y > threshold else { return }
        isLoadingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.appendTags()
            self?.isLoadingMore = false
        }
    }

    private func replaceTags() {
        batchIndex = 0
        tagView.removeAllTags()
        tagView.add(tags: buildTags(batch: batchIndex, repeatCount: 4))
        tagView.reload()
    }

    private func appendTags() {
        batchIndex += 1
        tagView.add(tags: buildTags(batch: batchIndex, repeatCount: 2))
        tagView.reload()
    }

    private func buildTags(batch: Int, repeatCount: Int) -> [TextTag] {
        (0..<repeatCount).flatMap { repeatIndex in
            TagSampleData.shortSampleWords.map { word in
                DemoUI.tag(text: batch == 0 ? word : "\(word) \(batch).\(repeatIndex + 1)")
            }
        }
    }
}
