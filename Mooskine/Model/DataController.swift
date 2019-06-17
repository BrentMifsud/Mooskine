//
//  DataController.swift
//  Mooskine
//
//  Created by Brent Mifsud on 2019-06-16.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

class DataController {
	let persistentContainer: NSPersistentContainer

	var viewContext: NSManagedObjectContext {
		return persistentContainer.viewContext
	}

	init(modelName: String){
		persistentContainer = NSPersistentContainer(name: modelName)
	}

	func load(completion: (() -> Void)? = nil) {
		persistentContainer.loadPersistentStores { (storeDescription, error) in
			guard error == nil else {
				fatalError(error!.localizedDescription)
			}

			self.autoSaveViewContext()

			completion?()
		}
	}
}

extension DataController {
	func autoSaveViewContext(interval: TimeInterval = 30) {
		guard interval > 0 else {
			print("Cannot set negative autosave interval")
			return
		}

		if viewContext.hasChanges {
			try? viewContext.save()
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
			self.autoSaveViewContext(interval: interval)
		}
	}
}
