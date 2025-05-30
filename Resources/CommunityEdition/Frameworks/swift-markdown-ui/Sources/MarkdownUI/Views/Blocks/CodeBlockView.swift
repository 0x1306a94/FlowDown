import SwiftUI

struct CodeBlockView: View {
    @Environment(\.theme.codeBlock) private var codeBlock
    @Environment(\.codeSyntaxHighlighter) private var codeSyntaxHighlighter

    private let fenceInfo: String?
    private let content: String

    init(fenceInfo: String?, content: String) {
        self.fenceInfo = fenceInfo
        self.content = content.hasSuffix("\n") ? String(content.dropLast()) : content
    }

    var body: some View {
        codeBlock.makeBody(
            configuration: .init(
                language: fenceInfo,
                content: content,
                label: .init(label)
            )
        )
    }

    private var label: some View {
        codeSyntaxHighlighter.highlightCode(content, language: fenceInfo)
            .textStyleFont()
            .textStyleForegroundColor()
    }
}
