//
//  UIViewControllerExtension.swift
//  UpcomingEvents
//
//  Created by Geisel Roque on 05/08/22.
//

import Foundation
import UIKit

extension UIViewController {
  func customAlert(title: String, message: String, completion: ((UIAlertAction) -> Void)?)  {
    let alert = UIAlertController(title: title, message: message,preferredStyle: .alert)
    let action = UIAlertAction(title: "Accept", style: .default, handler: completion)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}
