//
// MIT License
//
// Copyright (c) 2017 Marcus Ramsden
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

enum TextPromptResult {
    case submitted(String)
    case cancelled
}

typealias TextPromptCompletion = (TextPromptResult) -> ()

protocol AlertViewPresenter {

    func presentTextInput(title: String, message: String?, actionTitle: String, completion: @escaping TextPromptCompletion)

}

class WindowAlertViewPresenter: AlertViewPresenter {

    func presentTextInput(title: String, message: String?, actionTitle: String, completion textPromptCompletion: @escaping TextPromptCompletion) {
        let alertWindow = makeAlertWindow()
        let alertViewController = makeAlertViewController(title: title, message: message, actionTitle: actionTitle)
        alertViewController.completion = textPromptCompletion
        alertViewController.alertWindow = alertWindow
        alertWindow.isHidden = false
    }

    private func makeAlertViewController(title: String, message: String?, actionTitle: String) -> AlertViewController {
        let alertController = AlertViewController()
        alertController.alertTitle = title
        alertController.alertMessage = message
        alertController.actionTitle = actionTitle
        return alertController
    }

    private func makeAlertWindow() -> UIWindow {
        let window = UIWindow()
        window.windowLevel = UIWindowLevelAlert + 1
        window.backgroundColor = .clear
        return window
    }

}

class AlertViewController: UIViewController {

    var alertTitle: String? = nil
    var alertMessage: String? = nil
    var actionTitle: String? = nil
    var completion: TextPromptCompletion = { _ in }
    var alertWindow: UIWindow? = nil {
        didSet {
            alertWindow?.rootViewController = self
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let alertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert
        )
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(UIAlertAction(
            title: NSLocalizedString("dialog_cancel_action", comment: "Create column dialog cancel"),
            style: .cancel,
            handler: { [weak self] _ in
                self?.finish(.cancelled)
        }))
        alertController.addAction(UIAlertAction(
            title: actionTitle,
            style: .default,
            handler: { [weak self] _ in
                let input = alertController.textFields?.first?.text ?? ""
                self?.finish(.submitted(input))
        }))
        present(alertController, animated: animated, completion: nil)
    }

    func finish(_ result: TextPromptResult) {
        completion(result)
        alertWindow?.isHidden = true
        alertWindow = nil
    }

}
