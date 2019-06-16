//
//  NotesListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, UITableViewDataSource {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    var notebook: Notebook!

	var notes: [Note] = []

	var dataController: DataController!

    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem

		let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
		let predicate = NSPredicate(format: "notebook == %@", notebook)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = [sortDescriptor]

		if let result = try? dataController.viewContext.fetch(fetchRequest) {
			notes = result
			tableView.reloadData()
		}

        updateEditButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {

		let note = Note(context: dataController.viewContext)
		note.text = "Example: Get Milk"
		note.creationDate = Date()
		note.notebook = notebook

		do {
			try dataController.viewContext.save()

			notes.insert(note, at: 0)

			tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)

			updateEditButtonState()
		} catch {
			presentErrorAlert(title: "Unable to Add Note", message: "The following error occured:\n\(error.localizedDescription)")
		}
    }

    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
		let noteToDelete = note(at: indexPath)

		dataController.viewContext.delete(noteToDelete)

		do {
			try dataController.viewContext.save()

			notes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			if numberOfNotes == 0 {
				setEditing(false, animated: true)
			}
			updateEditButtonState()
		} catch {
			presentErrorAlert(title: "Unable to Delete Note", message: "The following error occured:\n\(error.localizedDescription)")
		}
    }

    func updateEditButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = numberOfNotes > 0
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfNotes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNote = note(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell

        // Configure cell
        cell.textPreviewLabel.text = aNote.text
		if let creationDate = aNote.creationDate {
			cell.dateLabel.text = dateFormatter.string(from: creationDate)
		}

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }

    // Helpers

    var numberOfNotes: Int { return notes.count }

    func note(at indexPath: IndexPath) -> Note {
        return notes[indexPath.row]
    }

    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = note(at: indexPath)

                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
