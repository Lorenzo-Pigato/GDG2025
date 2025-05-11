import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let menu = NSMenu()

        // Add styled title item
        let titleItem = NSMenuItem(title: "MemFlow", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false // Make it non-interactive
        let titleFont = NSFont.boldSystemFont(ofSize: 13)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont,
            .foregroundColor: NSColor.labelColor // Standard label color
        ]
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.secondaryLabelColor // Secondary label color for subtitle
        ]

        let titleString = NSMutableAttributedString(string: "MemFlow\n", attributes: titleAttributes)
        let subtitleString = NSAttributedString(string: "your suggested workflows", attributes: subtitleAttributes)
        titleString.append(subtitleString)

        titleItem.attributedTitle = titleString
        menu.addItem(titleItem)
        menu.addItem(NSMenuItem.separator()) // Separator after the title

        // Load and add workflow items from file
        let path = FileManager.default.currentDirectoryPath + "/workflows.txt"
        if let content = try? String(contentsOfFile: path) {
            for line in content.split(separator: "\n") where !line.isEmpty {
                let item = NSMenuItem(title: String(line), action: #selector(menuItemClicked(_:)), keyEquivalent: "")
                item.target = self
                // Add a small indent to workflow items
                item.indentationLevel = 1
                // You might want to store the index or workflow identifier with the menu item
                // For now, we rely on the menu item's position relative to the separators and title.
                // A more robust solution might involve subclassing NSMenuItem or using a dictionary.
                menu.addItem(item)
            }
        }

        // Add separator before the input prompt
        menu.addItem(NSMenuItem.separator())

        // Add the input prompt menu item
        let inputPromptItem = NSMenuItem(title: "Ask MemFlow...", action: #selector(showInputWindow(_:)), keyEquivalent: "")
        inputPromptItem.target = self // Set target to self to call the action method
        // Style this item to make the text more visible
        let promptAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12),
            .foregroundColor: NSColor.labelColor // Changed to a more visible color
        ]
        inputPromptItem.attributedTitle = NSAttributedString(string: "Ask MemFlow...", attributes: promptAttributes)
        menu.addItem(inputPromptItem)


        // Set up the status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "🧠" // Your desired icon/title
        statusItem?.menu = menu // Assign the constructed menu

        // Note: To provide actual text input, clicking "Ask MemFlow..." should
        // trigger showing a separate small window or popover containing an NSTextField.
        // Implementing that window/popover is beyond the scope of this menu setup.
    }

    // Action method for workflow items
    @objc func menuItemClicked(_ sender: NSMenuItem) {
        // Re-calculate the workflow index based on the menu structure
        // This approach is fragile if the menu structure changes.
        // A better approach would be to store the index or identifier directly with the menu item.
        if let menu = sender.menu,
           let index = menu.items.firstIndex(of: sender) {
            // Subtract 2 for the title item and 1 for the first separator
            // Then subtract 1 for the separator before the prompt
            // The prompt item itself is at the end.
            // So, items before the separator before the prompt are workflow items.
            // Find the index of the separator before the prompt item.
            if let promptSeparatorIndex = menu.items.firstIndex(where: { $0.isSeparatorItem && menu.items.firstIndex(of: $0)! > menu.items.firstIndex(of: menu.items.first(where: { $0.isSeparatorItem })!)! }) {
                 if index > (menu.items.firstIndex(where: { $0.isSeparatorItem }) ?? 1) && index < promptSeparatorIndex {
                     let workflowIndex = index - (menu.items.firstIndex(where: { $0.isSeparatorItem }) ?? 1) - 1 // Adjust index calculation
                     print("Clicked workflow item at index: \(workflowIndex)") // Debug print

                     let process = Process()
                     process.executableURL = URL(fileURLWithPath: ".venv/bin/python3")
                     process.arguments = [
                         FileManager.default.currentDirectoryPath + "/backend/macOS-use/main.py",
                         String(workflowIndex)
                     ]
                     do {
                         try process.run()
                         // Optionally, wait until the process finishes
                         // process.waitUntilExit()
                         // print("Python script finished with exit code: \(process.terminationStatus)")
                     } catch {
                         print("Failed to run python script: \(error)")
                     }
                 }
            }
        }
    }

    // Placeholder action method for the input prompt item
    @objc func showInputWindow(_ sender: NSMenuItem) {
        print("Input prompt item clicked. Implement showing an input window/popover here.")
        // TODO: Implement the logic to display a separate window or popover
        // containing an NSTextField for user input.
    }
}

// Standard boilerplate to run the application
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory) // Accessory policy keeps the app out of the Dock
app.run()
