//
//  NoteDetailsViewController+ToolbarExtension.swift
//  Mooskine
//
//  Created by Brent Mifsud on 2019-06-30.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Toolbar

extension NoteDetailsViewController {
	/// Returns an array of toolbar items. Used to configure the view controller's
	/// `toolbarItems' property, and to configure an accessory view for the
	/// text view's keyboard that also displays these items.
	func makeToolbarItems() -> [UIBarButtonItem] {
		let trash = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteTapped(sender:)))
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

		return [trash, space]
	}

	/// Configure the current toolbar
	func configureToolbarItems() {
		toolbarItems = makeToolbarItems()
		navigationController?.setToolbarHidden(false, animated: false)
	}

	/// Configure the text view's input accessory view -- this is the view that
	/// appears above the keyboard. We'll return a toolbar populated with our
	/// view controller's toolbar items, so that the toolbar functionality isn't
	/// hidden when the keyboard appears
	func configureTextViewInputAccessoryView() {
		let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
		toolbar.items = makeToolbarItems()
		textView.inputAccessoryView = toolbar
	}

	@IBAction func deleteTapped(sender: Any) {
		showDeleteAlert()
	}

	// MARK: Helper methods for actions
	private func showDeleteAlert() {
		let alert = UIAlertController(title: "Delete Note?", message: "Are you sure you want to delete the current note?", preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
			guard let strongSelf = self else { return }
			strongSelf.onDelete?()
		}

		alert.addAction(cancelAction)
		alert.addAction(deleteAction)
		present(alert, animated: true, completion: nil)
	}
}
