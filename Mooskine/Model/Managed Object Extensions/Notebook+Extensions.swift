//
//  Notebook+Extensions.swift
//  Mooskine
//
//  Created by Brent Mifsud on 2019-06-17.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Notebook {
	public override func awakeFromInsert() {
		super.awakeFromInsert()
		creationDate = Date()
	}
}
