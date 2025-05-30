//
//  ConversationListView.swift
//  FlowDown
//
//  Created by 秋星桥 on 2/3/25.
//

import ChidoriMenu
import Combine
import Foundation
import Storage
import UIKit

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.locale = .current
    return formatter
}()

class ConversationListView: UIView {
    let tableView: UITableView
    let dataSource: DataSource

    var cancellables: Set<AnyCancellable> = []

    typealias DataIdentifier = Conversation.ID
    typealias SectionIdentifier = String

    typealias DataSource = UITableViewDiffableDataSource<SectionIdentifier, DataIdentifier>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionIdentifier, DataIdentifier>

    let selection = CurrentValueSubject<Conversation.ID?, Never>(nil)

    weak var delegate: Delegate? {
        didSet { delegate?.conversationListView(didSelect: selection.value) }
    }

    var keepMyFocusTimer: Timer? = nil

    init() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(Cell.self, forCellReuseIdentifier: "Cell")

        dataSource = .init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            tableView.separatorColor = .clear
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
            let conv = ConversationManager.shared.conversation(identifier: itemIdentifier)
            cell.use(conv)
            return cell
        }
        dataSource.defaultRowAnimation = .fade

        super.init(frame: .zero)
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.separatorColor = .clear
        tableView.allowsMultipleSelection = false
        tableView.selectionFollowsFocus = true
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        selection
            .ensureMainThread()
            .sink { [weak self] identifier in
                guard let self else { return }
                var selectedIndexPath = Set(tableView.indexPathsForSelectedRows ?? [])
                if let identifier {
                    if let indexPath = dataSource.indexPath(for: identifier) {
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                        selectedIndexPath.remove(indexPath)
                    }
                }
                for index in selectedIndexPath {
                    tableView.deselectRow(at: index, animated: false)
                }
            }
            .store(in: &cancellables)

        selection
            .removeDuplicates()
            .ensureMainThread()
            .sink { [weak self] identifier in
                guard let self else { return }
                delegate?.conversationListView(didSelect: identifier)
            }
            .store(in: &cancellables)

        ConversationManager.shared.conversations
            .ensureMainThread()
            .sink { [weak self] _ in
                self?.updateDataSource()
            }
            .store(in: &cancellables)

        let timer = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            keepAtLeastOncFocus()
        }
        RunLoop.main.add(timer, forMode: .common)
        keepMyFocusTimer = timer
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    deinit {
        keepMyFocusTimer?.invalidate()
        keepMyFocusTimer = nil
    }

    func updateDataSource() {
        let list = ConversationManager.shared.conversations.value
        guard !list.isEmpty else {
            _ = ConversationManager.shared.initialConversation()
            return
        }

        var snapshot = Snapshot()
        for item in list {
            let section = dateFormatter.string(from: item.creation)
            if !snapshot.sectionIdentifiers.contains(section) {
                snapshot.appendSections([section])
            }
            snapshot.appendItems([item.id], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)

        let visibleRows = tableView.indexPathsForVisibleRows ?? []
        let visibleItemIdentifiers = visibleRows
            .map { dataSource.itemIdentifier(for: $0) }
            .compactMap(\.self)
        snapshot.reconfigureItems(visibleItemIdentifiers)
        dataSource.apply(snapshot, animatingDifferences: false)

        keepAtLeastOncFocus()
    }

    func select(identifier: Conversation.ID) {
        selection.send(identifier)
    }

    func keepAtLeastOncFocus() {
        guard tableView.indexPathsForSelectedRows?.count ?? 0 == 0 else { return }
        let item = ConversationManager.shared.conversations.value.first
        if let item {
            select(identifier: item.id)
        } else {
            selection.send(nil)
        }
    }
}
