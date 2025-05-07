import SwiftUI

/// A type that applies a custom appearance to blocks and text inlines in a Markdown view.
///
/// A theme combines the different text and block styles you can customize in a ``Markdown`` view.
///
/// You can set the current Markdown theme in a view hierarchy by using the `markdownTheme(_:)` modifier.
///
/// ```swift
/// Markdown {
///   """
///   You can quote text with a `>`.
///
///   > Outside of a dog, a book is man's best friend. Inside of a
///   > dog it's too dark to read.
///
///   – Groucho Marx
///   """
/// }
/// .markdownTheme(.gitHub)
/// ```
///
/// ![](GitHubBlockquote)
///
/// To override a specific text style from the current theme, use the `markdownTextStyle(_:textStyle:)`
/// modifier.  The following example shows how to override the ``Theme/code`` text style.
///
/// ```swift
/// Markdown {
///   """
///   Use `git status` to list all new or modified files
///   that haven't yet been committed.
///   """
/// }
/// .markdownTextStyle(\.code) {
///   FontFamilyVariant(.monospaced)
///   FontSize(.em(0.85))
///   ForegroundColor(.purple)
///   BackgroundColor(.purple.opacity(0.25))
/// }
/// ```
///
/// ![](CustomInlineCode)
///
/// You can also use the `markdownBlockStyle(_:body:)` modifier to override a specific block style. For example, you can
/// override only the ``Theme/blockquote`` block style, leaving other block styles untouched.
///
/// ```swift
/// Markdown {
///   """
///   You can quote text with a `>`.
///
///   > Outside of a dog, a book is man's best friend. Inside of a
///   > dog it's too dark to read.
///
///   – Groucho Marx
///   """
/// }
/// .markdownBlockStyle(\.blockquote) { configuration in
///   configuration.label
///     .padding()
///     .markdownTextStyle {
///       FontCapsVariant(.lowercaseSmallCaps)
///       FontWeight(.semibold)
///       BackgroundColor(nil)
///     }
///     .overlay(alignment: .leading) {
///       Rectangle()
///         .fill(Color.teal)
///         .frame(width: 4)
///     }
///     .background(Color.teal.opacity(0.5))
/// }
/// ```
///
/// ![](CustomBlockquote)
///
/// To create a theme, start by instantiating an empty `Theme` and chain together the different text and
/// block styles in a single expression.
///
/// ```swift
/// let myTheme = Theme()
///   .code {
///     FontFamilyVariant(.monospaced)
///     FontSize(.em(0.85))
///   }
///   .link {
///     ForegroundColor(.purple)
///   }
///   // More text styles...
///   .paragraph { configuration in
///     configuration.label
///       .relativeLineSpacing(.em(0.25))
///       .markdownMargin(top: 0, bottom: 16)
///   }
///   .listItem { configuration in
///     configuration.label
///       .markdownMargin(top: .em(0.25))
///   }
///   // More block styles...
/// ```
public struct Theme: Sendable {
    /// The default text style.
    public var text: TextStyle = EmptyTextStyle()

    /// The inline code style.
    public var code: TextStyle = FontFamilyVariant(.monospaced)

    /// The emphasis style.
    public var emphasis: TextStyle = FontStyle(.italic)

    /// The strong style.
    public var strong: TextStyle = FontWeight(.semibold)

    /// The strikethrough style.
    public var strikethrough: TextStyle = StrikethroughStyle(.single)

    /// The link style.
    public var link: TextStyle = EmptyTextStyle()

    var headings = Array(
        repeating: BlockStyle<BlockConfiguration> { $0.label },
        count: 6
    )

    /// The level 1 heading style.
    public var heading1: BlockStyle<BlockConfiguration> {
        get { headings[0] }
        set { headings[0] = newValue }
    }

    /// The level 2 heading style.
    public var heading2: BlockStyle<BlockConfiguration> {
        get { headings[1] }
        set { headings[1] = newValue }
    }

    /// The level 3 heading style.
    public var heading3: BlockStyle<BlockConfiguration> {
        get { headings[2] }
        set { headings[2] = newValue }
    }

    /// The level 4 heading style.
    public var heading4: BlockStyle<BlockConfiguration> {
        get { headings[3] }
        set { headings[3] = newValue }
    }

    /// The level 5 heading style.
    public var heading5: BlockStyle<BlockConfiguration> {
        get { headings[4] }
        set { headings[4] = newValue }
    }

    /// The level 6 heading style.
    public var heading6: BlockStyle<BlockConfiguration> {
        get { headings[5] }
        set { headings[5] = newValue }
    }

    /// The paragraph style.
    public var paragraph = BlockStyle<BlockConfiguration> { $0.label }

    /// The blockquote style.
    public var blockquote = BlockStyle<BlockConfiguration> { $0.label }

    /// The code block style.
    public var codeBlock = BlockStyle<CodeBlockConfiguration> { $0.label }

    /// The image style.
    public var image = BlockStyle<BlockConfiguration> { $0.label }

    /// The list style.
    public var list = BlockStyle<BlockConfiguration> { $0.label }

    /// The list item style.
    public var listItem = BlockStyle<BlockConfiguration> { $0.label }

    /// The task list marker style.
    public var taskListMarker = BlockStyle.checkmarkSquare

    /// The bulleted list marker style.
    public var bulletedListMarker = BlockStyle.discCircleSquare

    /// The numbered list marker style.
    public var numberedListMarker = BlockStyle.decimal

    /// The table style.
    public var table = BlockStyle<BlockConfiguration> { $0.label }

    /// The table cell style.
    public var tableCell = BlockStyle<TableCellConfiguration> { $0.label }

    /// The thematic break style.
    public var thematicBreak = BlockStyle { Divider() }

    /// Creates a theme with default text styles.
    public init() {}
}

public extension Theme {
    /// Adds a default text style to the theme.
    /// - Parameter text: A text style builder that returns the default text style.
    func text(@TextStyleBuilder text: () -> some TextStyle) -> Theme {
        var theme = self
        theme.text = text()
        return theme
    }

    /// Adds an inline code style to the theme.
    /// - Parameter code: A text style builder that returns the inline code style.
    func code(@TextStyleBuilder code: () -> some TextStyle) -> Theme {
        var theme = self
        theme.code = code()
        return theme
    }

    /// Adds an emphasis style to the theme.
    /// - Parameter emphasis: A text style builder that returns the emphasis style.
    func emphasis(@TextStyleBuilder emphasis: () -> some TextStyle) -> Theme {
        var theme = self
        theme.emphasis = emphasis()
        return theme
    }

    /// Adds a strong style to the theme.
    /// - Parameter strong: A text style builder that returns the strong style.
    func strong(@TextStyleBuilder strong: () -> some TextStyle) -> Theme {
        var theme = self
        theme.strong = strong()
        return theme
    }

    /// Adds a strikethrough style to the theme.
    /// - Parameter strikethrough: A text style builder that returns the strikethrough style.
    func strikethrough(@TextStyleBuilder strikethrough: () -> some TextStyle) -> Theme {
        var theme = self
        theme.strikethrough = strikethrough()
        return theme
    }

    /// Adds a link style to the theme.
    /// - Parameter link: A text style builder that returns the link style.
    func link(@TextStyleBuilder link: () -> some TextStyle) -> Theme {
        var theme = self
        theme.link = link()
        return theme
    }
}

public extension Theme {
    /// Adds a level 1 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 1 heading.
    func heading1(
        @ViewBuilder body: @escaping (_ configuration: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading1 = .init(body: body)
        return theme
    }

    /// Adds a level 2 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 2 heading.
    func heading2(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading2 = .init(body: body)
        return theme
    }

    /// Adds a level 3 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 3 heading.
    func heading3(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading3 = .init(body: body)
        return theme
    }

    /// Adds a level 4 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 4 heading.
    func heading4(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading4 = .init(body: body)
        return theme
    }

    /// Adds a level 5 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 5 heading.
    func heading5(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading5 = .init(body: body)
        return theme
    }

    /// Adds a level 6 heading style to the theme.
    /// - Parameter body: A view builder that returns a customized level 6 heading.
    func heading6(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.heading6 = .init(body: body)
        return theme
    }

    /// Adds a paragraph style to the theme.
    /// - Parameter body: A view builder that returns a customized paragraph.
    func paragraph(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.paragraph = .init(body: body)
        return theme
    }

    /// Adds a blockquote style to the theme.
    /// - Parameter body: A view builder that returns a customized blockquote.
    func blockquote(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.blockquote = .init(body: body)
        return theme
    }

    /// Adds a code block style to the theme.
    /// - Parameter body: A view builder that returns a customized code block.
    func codeBlock(
        @ViewBuilder body: @escaping (_ configuration: CodeBlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.codeBlock = .init(body: body)
        return theme
    }

    /// Adds an image style to the theme.
    /// - Parameter body: A view builder that returns a customized image.
    func image(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.image = .init(body: body)
        return theme
    }

    /// Adds a list style to the theme.
    /// - Parameter body: A view builder that returns a customized list.
    func list(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.list = .init(body: body)
        return theme
    }

    /// Adds a list item style to the theme.
    /// - Parameter body: A view builder that returns a customized list item.
    func listItem(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.listItem = .init(body: body)
        return theme
    }

    /// Adds a task list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized task list marker.
    func taskListMarker(_ taskListMarker: BlockStyle<TaskListMarkerConfiguration>) -> Theme {
        var theme = self
        theme.taskListMarker = taskListMarker
        return theme
    }

    /// Adds a task list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized task list marker.
    func taskListMarker(
        @ViewBuilder body: @escaping (_ configuration: TaskListMarkerConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.taskListMarker = .init(body: body)
        return theme
    }

    /// Adds a bulleted list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized bulleted list marker.
    func bulletedListMarker(
        _ bulletedListMarker: BlockStyle<ListMarkerConfiguration>
    ) -> Theme {
        var theme = self
        theme.bulletedListMarker = bulletedListMarker
        return theme
    }

    /// Adds a bulleted list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized bulleted list marker.
    func bulletedListMarker(
        @ViewBuilder body: @escaping (_ configuration: ListMarkerConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.bulletedListMarker = .init(body: body)
        return theme
    }

    /// Adds a numbered list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized numbered list marker.
    func numberedListMarker(
        _ numberedListMarker: BlockStyle<ListMarkerConfiguration>
    ) -> Theme {
        var theme = self
        theme.numberedListMarker = numberedListMarker
        return theme
    }

    /// Adds a numbered list marker style to the theme.
    /// - Parameter body: A view builder that returns a customized numbered list marker.
    func numberedListMarker(
        @ViewBuilder body: @escaping (_ configuration: ListMarkerConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.numberedListMarker = .init(body: body)
        return theme
    }

    /// Adds a table style to the theme.
    /// - Parameter body: A view builder that returns a customized table.
    func table(
        @ViewBuilder body: @escaping (_ label: BlockConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.table = .init(body: body)
        return theme
    }

    /// Adds a table cell style to the theme.
    /// - Parameter body: A view builder that returns a customized table cell.
    func tableCell(
        @ViewBuilder body: @escaping (_ configuration: TableCellConfiguration) -> some View
    ) -> Theme {
        var theme = self
        theme.tableCell = .init(body: body)
        return theme
    }

    /// Adds a thematic break style to the theme.
    /// - Parameter body: A view builder that returns a customized thematic break.
    func thematicBreak(@ViewBuilder body: @escaping () -> some View) -> Theme {
        var theme = self
        theme.thematicBreak = .init(body: body)
        return theme
    }
}

public extension Theme {
    /// The text background color of the theme extracted from the ``Theme/text`` style.
    var textBackgroundColor: Color? {
        var attributes = AttributeContainer()
        text._collectAttributes(in: &attributes)
        return attributes.backgroundColor
    }
}
