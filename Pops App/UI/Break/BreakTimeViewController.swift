
import UIKit
import UserNotifications

class BreakTimeViewController: UIViewController, BreakTimeViewModelDelegate, BreakTimeViewModelProgressBarDelegate, BreakButtonDelegate {

    var viewModel: BreakTimeViewModel!
    let center = UNUserNotificationCenter.current()
    
    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    lazy var itemWidth: CGFloat = self.view.frame.width * (269/self.view.frame.width)
    lazy var itemHeight: CGFloat = self.view.frame.height * (45/self.view.frame.height)
    
    let talkToCoachButton = UIButton()
    let characterMessageHeader = UILabel()
    let characterMessageBody = UILabel()
    let circleBackgroundForCharacterImageView = UIImageView()
    let settingsButton = UIButton()
    let dismissIcon = UIButton()
    
    let contentView = UIView()
    let settingsVC = SettingsViewController()
    
    let progressBar = UIView()
    var progressBarWidthAnchor: NSLayoutConstraint! {
        didSet {
            self.view.layoutIfNeeded()
        }
    }
    
    let coachWindowView = UIView()
    let coachIcon = UIImageView()
    
    var coachBottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        viewModel = BreakTimeViewModel(delegate: self, progressBarDelegate: self)
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        setupProgressBar()
        setupSettingsButton()
        setupCancelSettingsButton()
        setupCoachWindow()
        setupCoachIcon()
        setupCharacterMessageHeader()
        setupCharacterMessageBody()
        setupTalkToCoachButton()

        self.viewModel.breakTimerDelegate = settingsVC
        settingsVC.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(appEnteredForeground), name: NSNotification.Name(rawValue: "appEnteredForeground"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.delegate = self
        animateCoachPopup()
        viewModel.dataStore.defaults.set(true, forKey: "returningUser")
        UIScreen.main.brightness = 0.75
    }
    
    @objc func appEnteredForeground() {
        if viewModel.dataStore.user.currentSession != nil {
            viewModel.updateTimers()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewModel.breakIsOn == false {
            breakTimeEndedUserNotificationRequest()
            viewModel.startTimer()
        }
    }

    func moveToProductivity() {
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in
            let productiveTimeViewController = ProductiveTimeViewController()
            productiveTimeViewController.modalPresentationStyle = .fullScreen
            self.present(productiveTimeViewController, animated: true, completion: nil)
        }
    }
    
    func moveToSessionEnded() {
        viewModel.breakTimer.invalidate()
        
        UIView.animate(withDuration: 0.7, animations: {
            self.coachBottomAnchorConstraint.constant = 100
            self.view.layoutIfNeeded()
        }) { _ in
            let sessionEndedViewController = SessionEndedViewController()
            sessionEndedViewController.modalPresentationStyle = .fullScreen
            self.present(sessionEndedViewController, animated: true, completion: nil)
        }
    }
    
    func endBreakBttnPressed() {
        viewModel.breakIsOn = false
        viewModel.breakTimer.invalidate()
        viewModel.dataStore.user.currentSession?.cyclesRemaining -= 1
        if viewModel.dataStore.user.currentSession!.cyclesRemaining == 0 {
            moveToSessionEnded()
        }
        else {
            moveToProductivity()
        }
    }
    
    @objc func talkToCoach() {
        let breakViewModel = BreakViewModel()

        var randomIndex: Int
        var characterMessageHeader: String
        var characterMessageBody: String
        
        switch viewModel.dataStore.getCurrentCoach().name {
        case "Baba":
            randomIndex = Int(arc4random_uniform(UInt32(breakViewModel.babaBreakTasks.count)))
            characterMessageHeader = breakViewModel.babaBreakTasks[randomIndex].header
            characterMessageBody = breakViewModel.babaBreakTasks[randomIndex].body
        case "Pops":
            randomIndex = Int(arc4random_uniform(UInt32(breakViewModel.popsBreakTasks.count)))
            characterMessageHeader = breakViewModel.popsBreakTasks[randomIndex].header
            characterMessageBody = breakViewModel.popsBreakTasks[randomIndex].body
        case "Chad":
            randomIndex = Int(arc4random_uniform(UInt32(breakViewModel.chadBreakTasks.count)))
            characterMessageHeader = breakViewModel.chadBreakTasks[randomIndex].header
            characterMessageBody = breakViewModel.chadBreakTasks[randomIndex].body
        default:
            randomIndex = Int(arc4random_uniform(UInt32(breakViewModel.popsBreakTasks.count)))
            characterMessageHeader = breakViewModel.popsBreakTasks[randomIndex].header
            characterMessageBody = breakViewModel.popsBreakTasks[randomIndex].body
        }

        UIView.animate(withDuration: 0.3, animations: {
            self.characterMessageBody.alpha = 0
            self.characterMessageHeader.alpha = 0
            
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.characterMessageHeader.text = characterMessageHeader
                self.characterMessageBody.text = characterMessageBody
                self.characterMessageBody.alpha = 1
                self.characterMessageHeader.alpha = 1
            }, completion: nil)
        }
    }
}

extension BreakTimeViewController {
    func setupProgressBar() {
        view.addSubview(progressBar)
        progressBar.backgroundColor = Palette.salmon.color
        
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        progressBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        progressBarWidthAnchor = progressBar.widthAnchor.constraint(equalToConstant: 0.0)
        progressBarWidthAnchor.isActive = true
    }

    func setupSettingsButton() {
        settingsButton.setBackgroundImage(#imageLiteral(resourceName: "IC_Settings-Black"), for: .normal)

        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        settingsButton.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16.0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 24.0).isActive = true

        settingsButton.addTarget(self, action: #selector(presentSettingsVC), for: .touchUpInside)
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

        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageHeader.text = "Time for a break!"
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageHeader.text = viewModel.dataStore.user.currentCoach.breakStatements[randomIndex].header
        }

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
        
        if viewModel.dataStore.defaults.value(forKey: "returningUser") == nil {
            characterMessageBody.text = "I hope you your first session with me was productive."
        } else {
            let introStatments = viewModel.dataStore.user.currentCoach.introStatements
            let randomIndex = Int(arc4random_uniform(UInt32(introStatments.count)))
            characterMessageBody.text = viewModel.dataStore.user.currentCoach.breakStatements[randomIndex].body
        }
        
        view.addSubview(characterMessageBody)
        characterMessageBody.translatesAutoresizingMaskIntoConstraints = false
        characterMessageBody.topAnchor.constraint(equalTo: characterMessageHeader.bottomAnchor, constant: 8).isActive = true
        characterMessageBody.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        characterMessageBody.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
    }

    func setupTalkToCoachButton() {
        talkToCoachButton.backgroundColor = Palette.lightBlue.color
        talkToCoachButton.layer.cornerRadius = 2.0
        talkToCoachButton.layer.masksToBounds = true
        talkToCoachButton.setTitle(viewModel.dataStore.user.currentCoach.breakButtonText, for: .normal)
        talkToCoachButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 14.0)
        talkToCoachButton.addTarget(self, action: #selector(talkToCoach), for: .touchUpInside)

        view.addSubview(talkToCoachButton)
        talkToCoachButton.translatesAutoresizingMaskIntoConstraints = false
        talkToCoachButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        talkToCoachButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 269/viewWidth).isActive = true
        talkToCoachButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 45/viewHeight).isActive = true
        talkToCoachButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48).isActive = true
    }

    func animateCoachPopup() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.coachBottomAnchorConstraint.constant = 10
            self.view.layoutIfNeeded()
        }
    }
}

extension BreakTimeViewController {
    
    func setupCancelSettingsButton() {
        self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_Quit-Black"), for: .normal)
        self.dismissIcon.alpha = 0
        self.view.addSubview(self.dismissIcon)
        self.dismissIcon.translatesAutoresizingMaskIntoConstraints = false
        self.dismissIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0).isActive = true
        self.dismissIcon.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16.0).isActive = true
        self.dismissIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        self.dismissIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.dismissIcon.addTarget(self, action: #selector(self.dismissSettingVC), for: .touchUpInside)
    }
    
    @objc func presentSettingsVC() {
        
        view.insertSubview(self.contentView, aboveSubview: coachIcon)
        self.contentView.backgroundColor = UIColor.red
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.contentView.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 0).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        UIView.animate(withDuration: 0.2, animations: {
            self.settingsButton.alpha = 0
            self.dismissIcon.alpha = 1
            
            self.addChild(self.settingsVC)
            self.settingsVC.view.frame = self.contentView.bounds
            self.contentView.addSubview(self.settingsVC.view)
            self.settingsVC.didMove(toParent: self)
        })
        
    }
    
    @objc func dismissSettingVC() {
        self.contentView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.dismissIcon.alpha = 0
            self.settingsButton.alpha = 1
        })
    }

}

extension BreakTimeViewController {
    
    func breakTimeEndedUserNotificationRequest() {
        
        let content = UNMutableNotificationContent()
        content.title = viewModel.dataStore.user.currentCoach.breakNotificationStatements[0].header
        content.body = viewModel.dataStore.user.currentCoach.breakNotificationStatements[0].body
        content.sound = UNNotificationSound.default
        let breakTimerLength = (viewModel.dataStore.user.currentCoach.difficulty.baseBreakLength)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(breakTimerLength), repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }

}
