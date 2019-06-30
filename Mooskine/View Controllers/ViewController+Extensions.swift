//
//  ViewController+Extensions.swift
//  Mooskine
//
//  Created by Brent Mifsud on 2019-06-16.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
	func presentErrorAlert(title: String, message: String){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

		// Create actions
		let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

		//Add Actions
		alert.addAction(okAction)

		//Present Alert
		present(alert, animated: true, completion: nil)
	}
}
