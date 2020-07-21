
import UIKit

class SessionEndedViewController: UIViewController {

    let viewModel = SessionEndedViewModel()
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    let doneButton = UIButton()
    let extendHourButton = UIButton()
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    
    let headerView = UIView()
    
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeaderView()
        setupCoachWindow()
        setupCoachIcon()
        setupCharacterMessageHeader()
        setupCharacterMessageBody()
        setupDoneButton()
        setupExtendHourButton()
        selectSessionEndedState()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateCoachPopup()
        
        if !(viewModel.dataStore.user.currentSession?.mightCancelSession)! {
            
            if viewModel.dataStore.user.currentSession != nil {
                viewModel.dataStore.user.currentSession?.sessionTimer.invalidate()
                let totalHours = viewModel.dataStore.defaults.value(forKey: "totalHours") as? Int ?? 0
                let sessionHours = viewModel.dataStore.user.currentSession!.sessionHours
                let newTotal = totalHours + sessionHours
                viewModel.dataStore.defaults.set(newTotal, forKey: "totalHours")
                viewModel.dataStore.user.currentSession = nil
            }
            
        }
    }
    
    @objc func presentSetSessionVC() {

        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint?.constant = 120
            self.view.layoutIfNeeded()
        }) { (_) in
            if self.viewModel.dataStore.user.currentSession?.mightCancelSession == true {
                self.viewModel.dataStore.user.currentSession = nil
            }

            self.viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
            self.viewModel.dataStore.defaults.set(true, forKey: "returningUser")

            let setSessionVC = SetSessionViewController()
            setSessionVC.modalPresentationStyle = .fullScreen
            self.present(setSessionVC, animated: true, completion: nil)
        }

    }
    
    @objc func presentProductiveTimeVC() {

        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint?.constant = 120
            self.view.layoutIfNeeded()
        }) { (_) in

            if self.viewModel.dataStore.user.currentSession?.mightCancelSession == true {
                self.dismiss(animated: true, completion: nil)
            } else {
                self.viewModel.dataStore.defaults.set(false, forKey: "sessionActive")
                self.viewModel.startSessionOfLength(1)
                let productiveTimeVC = ProductiveTimeViewController()
                productiveTimeVC.modalPresentationStyle = .fullScreen
                self.present(productiveTimeVC, animated: true, completion: nil)
            }

        }

    }

}

extension SessionEndedViewController {

    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color

        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }

    func setupCoachWindow() {
        view.addSubview(coachWindowView)
        coachWindowView.translatesAutoresizingMaskIntoConstraints = false
        coachWindowView.backgroundColor = Palette.salmon.color
        coachWindowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        coachWindowView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80.0).isActive = true
        coachWindowView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        coachWindowView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        coachWindowView.layer.cornerRadius = 60.0
        coachWindowView.layer.masksToBounds = true
    }

    func setupCoachIcon() {
        coachIcon.image = viewModel.dataStore.user.currentCoach.icon
        coachIcon.contentMode = .scaleAspectFill

        coachWindowView.addSubview(coachIcon)
        coachIcon.translatesAutoresizingMaskIntoConstraints = false

        coachBottomAnchorConstraint = coachIcon.bottomAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 120)
        coachBottomAnchorConstraint.isActive = true
        coachIcon.centerXAnchor.constraint(equalTo: coachWindowView.centerXAnchor, constant: 0).isActive = true
        coachIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        coachIcon.widthAnchor.constraint(equalToConstant: 52).isActive = true
    }

    func setupCharacterMessageHeader() {
        characterMessageHeader.numberOfLines = 0
        characterMessageHeader.textColor = UIColor.black
        characterMessageHeader.textAlignment = .left
        characterMessageHeader.font = UIFont(name: "Avenir-Black", size: 14.0)


        view.addSubview(characterMessageHeader)
        characterMessageHeader.translatesAutoresizingMaskIntoConstraints = false
        characterMessageHeader.topAnchor.constraint(equalTo: coachWindowView.bottomAnchor, constant: 16).isActive = true
        characterMessageHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        characterMessageHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
    }

    func setupCharacterMessageBody() {
        characterMessageBody.numberOfLines = 0
        characterMessageBody.textColor = Palette.grey.color
        characterMessageBody.textAlignment = .left
        characterMessageBody.font = UIFont(name: "Avenir-Heavy", size: 14.0)


        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.topAnchor.constraint(equalTo: characterMessageHeader.bottomAnchor, constant: 8).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
    }

    func setupDoneButton() {
        doneButton.backgroundColor = Palette.lightGrey.color
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.alpha = 1
        doneButton.isEnabled = true
        doneButton.layer.cornerRadius = 2.0
        doneButton.layer.masksToBounds = true
        doneButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        doneButton.setTitleColor(Palette.darkText.color, for: .normal)
        doneButton.addTarget(self, action: #selector(presentSetSessionVC), for: .touchUpInside)
        
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        doneButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48).isActive = true
    }
    
    func setupExtendHourButton() {
        extendHourButton.backgroundColor = Palette.lightBlue.color
        extendHourButton.layer.cornerRadius = 2.0
        extendHourButton.layer.masksToBounds = true
   
        extendHourButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        extendHourButton.addTarget(self, action: #selector(presentProductiveTimeVC), for: .touchUpInside)
        
        view.addSubview(extendHourButton)
        extendHourButton.translatesAutoresizingMaskIntoConstraints = false
        extendHourButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        extendHourButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        extendHourButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        extendHourButton.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -18).isActive = true
    }

    func selectSessionEndedState() {
        if viewModel.dataStore.user.currentSession?.mightCancelSession == true {
            doneButton.setTitle("cancel session", for: .normal)
            extendHourButton.setTitle("continue", for: .normal)
            characterMessageBody.text = "If you cancel this session early you will disappoint your coach. Are you sure you want to give up now?"
            characterMessageHeader.text = "Cancel session?"
        } else {
            doneButton.setTitle("let me go", for: .normal)
            extendHourButton.setTitle("extend for an hour", for: .normal)
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.endSessionStatements[0].body
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.endSessionStatements[0].header
        }
    }

    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7) {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }

}
