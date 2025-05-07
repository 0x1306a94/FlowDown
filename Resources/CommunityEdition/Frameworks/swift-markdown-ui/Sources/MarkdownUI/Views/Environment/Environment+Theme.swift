import SwiftUI

public extension View {
    /// Sets the current ``Theme`` for the Markdown contents in a view hierarchy.
    /// - Parameter theme: The theme to set.
    func markdownTheme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
    }

    /// Replaces a specific text style of the current ``Theme`` with the given text style.
    /// - Parameters:
    ///   - keyPath: The ``Theme`` key path to the text style to replace.
    ///   - textStyle: A text style builder that returns the new text style to use for the given key path.
    func markdownTextStyle(
        _ keyPath: WritableKeyPath<Theme, TextStyle>,
        @TextStyleBuilder textStyle: () -> some TextStyle
    ) -> some View {
        environment((\EnvironmentValues.theme).appending(path: keyPath), textStyle())
    }

    /// Replaces a specific block style on the current ``Theme`` with a block style initialized with the given body closure.
    /// - Parameters:
    ///   - keyPath: The ``Theme`` key path to the block style to replace.
    ///   - body: A view builder that returns the customized block.
    func markdownBlockStyle(
        _ keyPath: WritableKeyPath<Theme, BlockStyle<Void>>,
        @ViewBuilder body: @escaping () -> some View
    ) -> some View {
        environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
    }

    /// Replaces a specific block style on the current ``Theme`` with a block style initialized with the given body closure.
    /// - Parameters:
    ///   - keyPath: The ``Theme`` key path to the block style to replace.
    ///   - body: A view builder that receives the block configuration and returns the customized block.
    func markdownBlockStyle<Configuration>(
        _ keyPath: WritableKeyPath<Theme, BlockStyle<Configuration>>,
        @ViewBuilder body: @escaping (_ configuration: Configuration) -> some View
    ) -> some View {
        environment((\EnvironmentValues.theme).appending(path: keyPath), .init(body: body))
    }

    /// Replaces the current ``Theme`` task list marker with the given list marker.
    func markdownTaskListMarker(
        _ value: BlockStyle<TaskListMarkerConfiguration>
    ) -> some View {
        environment(\.theme.taskListMarker, value)
    }

    /// Replaces the current ``Theme`` bulleted list marker with the given list marker.
    func markdownBulletedListMarker(
        _ value: BlockStyle<ListMarkerConfiguration>
    ) -> some View {
        environment(\.theme.bulletedListMarker, value)
    }

    /// Replaces the current ``Theme`` numbered list marker with the given list marker.
    func markdownNumberedListMarker(
        _ value: BlockStyle<ListMarkerConfiguration>
    ) -> some View {
        environment(\.theme.numberedListMarker, value)
    }
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = .basic
}
