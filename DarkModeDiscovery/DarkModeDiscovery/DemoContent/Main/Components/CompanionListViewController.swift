//
//  CompanionListViewController.swift
//  DarkModeDiscovery
//
//  Created by Mikhail A. Zhigulin of Novosibirsk.
//
//  Unlicensed Free Software.
//

import Cocoa
import ConsolePerseusLogger

class CompanionListViewController: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!

    var companionListSelectionHandler: ((Companion?) -> Void)?

    var companionList = [Companion]() {
        didSet {
            guard isViewLoaded else { return }

            reloadCompanionListAndSelectTheFirstIfNecessary()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.wantsLayer = true
        self.collectionView.backgroundColors = [NSColor.clear]
        self.view.wantsLayer = true

        reloadCompanionListAndSelectTheFirstIfNecessary()
    }

    private func reloadCompanionListAndSelectTheFirstIfNecessary() {

        if companionList.isEmpty {
            log.message("[\(type(of: self))].\(#function), it's empty!")
            return
        }

        collectionView.reloadData()
    }
}

extension CompanionListViewController: NSCollectionViewDataSource {

    func collectionView(_ collectionView: NSCollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        return companionList.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt
        indexPath: IndexPath) -> NSCollectionViewItem {

        let item = collectionView.makeItem(withIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "CompanionCollectionViewItem"),
            for: indexPath)

        if let companion = item as? CompanionCollectionViewItem {

            let one = companionList[(indexPath as NSIndexPath).item]
            companion.companion = one
        }

        return item
    }
}

extension CompanionListViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView,
                        didSelectItemsAt indexPaths: Set<IndexPath>) {
        handleSelectionChanged()
    }

    func collectionView(_ collectionView: NSCollectionView,
                        didDeselectItemsAt indexPaths: Set<IndexPath>) {
        handleSelectionChanged()
    }

    private func handleSelectionChanged() {
        guard let companionListSelectionHandler = companionListSelectionHandler else { return }

        let selectedCompanion: Companion?

        if let selectedIndexPath = collectionView.selectionIndexPaths.first,
            !companionList.isEmpty, (selectedIndexPath as NSIndexPath).item != -1 {
            selectedCompanion = companionList[(selectedIndexPath as NSIndexPath).item]
        } else {
            selectedCompanion = nil
        }

        companionListSelectionHandler(selectedCompanion)
    }
}
