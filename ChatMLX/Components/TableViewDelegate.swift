//
//  TableViewDelegate.swift
//  ChatMLX
//
//  Created by John Mai on 2024/4/13.
//

import AppKit
import Foundation

class TableRowView: NSTableRowView {
    override func drawSelection(in dirtyRect: NSRect) {
        if self.selectionHighlightStyle != .none {
            NSColor.gray.withAlphaComponent(0.1).setFill()
            NSBezierPath(rect: self.bounds).fill()
        }
    }
}

final class TableViewDelegate: NSObject, NSTableViewDelegate {
    var tableView: NSTableView? {
        didSet {
            if delegate == nil, let delegate = tableView?.delegate {
                print("5555")
                self.tableView?.delegate = self
                self.delegate = delegate
            }
        }
    }

    private weak var delegate: NSTableViewDelegate?

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int)
        -> NSView?
    {
        self.delegate?.tableView?(tableView, viewFor: tableColumn, row: row)
    }

    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        TableRowView()
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delegate?.tableViewSelectionDidChange?(notification)
    }
}
