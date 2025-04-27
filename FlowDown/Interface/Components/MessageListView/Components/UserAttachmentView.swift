//
//  Created by ktiays on 2025/1/31.
//  Copyright (c) 2025 ktiays. All rights reserved.
//

import RichEditor
import UIKit

final class UserAttachmentView: MessageListRowView {
    private lazy var attachmentsBar: AttachmentsBar = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)

        attachmentsBar.inset = .zero
        attachmentsBar.isDeletable = false
        attachmentsBar.collectionView.alwaysBounceHorizontal = false
        contentView.addSubview(attachmentsBar)
    }

    @available(*, unavailable)
    @MainActor required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        attachmentsBar.deleteAllItems()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let idealWidth = attachmentsBar.idealSize().width
        let bounds = contentView.bounds
        let width = min(idealWidth, bounds.width)
        attachmentsBar.frame = .init(
            x: bounds.width - width,
            y: 0,
            width: width,
            height: bounds.height
        )
    }

    func update(with attachments: MessageListView.Attachments) {
        for element in attachments.items {
            attachmentsBar.insert(item: element)
        }
    }
}
