//
//  ViewController.swift
//  PokemonApp
//
//  Created by Rafael Martins on 11/10/21.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var txtLogin: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!


    //MARK: Variables
    private let viewModel = LoginViewModel()
    var presentedVC: UIViewController?


    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        bindViewModel()
    }

    //MARK: Actions
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @IBAction func signIn(_ sender: Any) {
        let user = txtLogin.text?.lowercased() ?? ""
        let password = txtPassword.text?.lowercased() ?? ""
        viewModel.login(user: user, password: password)
    }

    @objc func didTapLogoutButton(_ sender: Any) {
        if let presentedVC = presentedViewController {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            presentedVC.view.window!.layer.add(transition, forKey: kCATransition)
        }

        dismiss(animated: false, completion: nil)

        presentedVC = nil
    }

    //MARK: BindViewModel
    private func bindViewModel() {
        viewModel.showHome = { [unowned self] in
            self.txtLogin.text? = ""
            self.txtPassword.text? = ""
            let storyBoard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
            if let presentedVC = (storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as? UITabBarController) {
                presentedVC.navigationItem.title = "Pokémon List"
                presentedVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                                               style: .plain,
                                                                               target: self,
                                                                               action: #selector(didTapLogoutButton(_:)))
                let nvc = UINavigationController(rootViewController: presentedVC)
                present(nvc, animated: false, pushing: true, completion: nil)
            }
        }

        viewModel.showError = { [unowned self] title, message in
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

}

extension UIViewController {
    open func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, pushing: Bool, completion: (() -> Void)? = nil) {

        if pushing {
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            view.window?.layer.add(transition, forKey: kCATransition)
            viewControllerToPresent.modalPresentationStyle = .fullScreen
            self.present(viewControllerToPresent, animated: false, completion: completion)
        } else {
            self.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
}

