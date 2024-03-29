//
//  NoteDetailsViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

class NoteDetailsViewController: UIViewController {
	deinit {
		removeSaveNotificationObserver()
	}

	/// A text view that displays a note's text
    @IBOutlet weak var textView: UITextView!

    /// The note being displayed and edited
    var note: Note!

    /// A closure that is run when the user asks to delete the current note
    var onDelete: (() -> Void)?

    /// A date formatter for the view controller's title text
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

	var dataController: DataController!

	var saveObserverToken: Any?

	/// The accessory view used when displaying the keyboard
	var keyboardToolbar: UIToolbar?

	override func viewDidLoad() {
		super.viewDidLoad()

		if let creationDate = note.creationDate {
			navigationItem.title = dateFormatter.string(from: creationDate)
		}
		textView.attributedText = note.attributedText

		// keyboard toolbar configuration
		configureToolbarItems()
		configureTextViewInputAccessoryView()

		addSaveNotificationObserver()
	}

    @IBAction func deleteNote(sender: Any) {
        presentDeleteNotebookAlert()
    }
}

// -----------------------------------------------------------------------------
// MARK: - Editing

extension NoteDetailsViewController {
    func presentDeleteNotebookAlert() {
        let alert = UIAlertController(title: "Delete Note", message: "Do you want to delete this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler))
        present(alert, animated: true, completion: nil)
    }

    func deleteHandler(alertAction: UIAlertAction) {
        onDelete?()
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITextViewDelegate

extension NoteDetailsViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
		note.attributedText = textView.attributedText
		try? dataController.viewContext.save()
    }
}
