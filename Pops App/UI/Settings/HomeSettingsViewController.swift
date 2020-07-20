import Foundation
import UIKit

class HomeSettingsViewController: UIViewController {
    
    lazy var viewWidth: CGFloat = self.view.frame.width  //375
    lazy var viewHeight: CGFloat = self.view.frame.height  //667
    
    let progressBar = UIView()
    var progressBarWidth = NSLayoutConstraint()
    let headerView = UIView()
    let dismissIcon = UIButton()

    var pops: CustomCharacterView!
    var chad: CustomCharacterView!
    var baba: CustomCharacterView!
    var coachNameLabel = UILabel()
    var coachBioLabel = UILabel()
    
    var usersCurrentCoach: String {
        return DataStore.singleton.user.currentCoach.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupHeaderView()
        setupCancelSettingsButton()        
        setupCharacterViews()
        setupCoachNameLabel()
        setupCoachBioLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForSelectedCharacter()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
    }

    func checkForSelectedCharacter() {
        switch usersCurrentCoach {
        case "Pops":
            baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            pops.circleBackgroundView.backgroundColor = Palette.salmon.color
            chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        case "Chad":
            baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            chad.circleBackgroundView.backgroundColor = Palette.salmon.color
        case "Baba":
            baba.circleBackgroundView.backgroundColor = Palette.salmon.color
            pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        default:
            baba.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            pops.circleBackgroundView.backgroundColor = Palette.lightGrey.color
            chad.circleBackgroundView.backgroundColor = Palette.lightGrey.color
        }

        coachNameLabel.text = DataStore.singleton.getCurrentCoach().name
        coachBioLabel.text = DataStore.singleton.getCurrentCoach().bio
    }

    func setupCharacterViews() {
 
        pops = CustomCharacterView(image: UIImage(named: "IC_POPS")!)
        let popsGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectPopsCharacter))
        pops.addGestureRecognizer(popsGesture)
        view.addSubview(pops)

        baba = CustomCharacterView(image: UIImage(named: "IC_BABA")!)
        let babaGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectBabaCharacter))
        baba.addGestureRecognizer(babaGesture)
        view.addSubview(baba)

        chad = CustomCharacterView(image: UIImage(named: "IC_CHAD")!)
        let chadGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectChadCharacter))
        chad.addGestureRecognizer(chadGesture)
        view.addSubview(chad)

        pops.translatesAutoresizingMaskIntoConstraints = false
        pops.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64).isActive = true
        pops.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pops.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pops.widthAnchor.constraint(equalToConstant: 100).isActive = true

        baba.translatesAutoresizingMaskIntoConstraints = false
        baba.centerYAnchor.constraint(equalTo: pops.centerYAnchor).isActive = true
        baba.trailingAnchor.constraint(equalTo: pops.leadingAnchor, constant: -16).isActive = true
        baba.heightAnchor.constraint(equalToConstant: 100).isActive = true
        baba.widthAnchor.constraint(equalToConstant: 100).isActive = true

        chad.translatesAutoresizingMaskIntoConstraints = false
        chad.centerYAnchor.constraint(equalTo: pops.centerYAnchor).isActive = true
        chad.leadingAnchor.constraint(equalTo: pops.trailingAnchor, constant: 16).isActive = true
        chad.heightAnchor.constraint(equalToConstant: 100).isActive = true
        chad.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func setupCoachNameLabel() {
        coachNameLabel.numberOfLines = 0
        coachNameLabel.textColor = UIColor.black
        coachNameLabel.textAlignment = .left
        coachNameLabel.font = UIFont(name: "Avenir-Black", size: 14.0)

        view.addSubview(coachNameLabel)
        coachNameLabel.translatesAutoresizingMaskIntoConstraints = false
        coachNameLabel.topAnchor.constraint(equalTo: pops.bottomAnchor, constant: 16).isActive = true
        coachNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        coachNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
    }

    func setupCoachBioLabel() {
        coachBioLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        coachBioLabel.numberOfLines = 0
        coachBioLabel.textColor = Palette.grey.color
        coachBioLabel.textAlignment = .left
        coachBioLabel.font = UIFont(name: "Avenir-Heavy", size: 14.0)

        view.addSubview(coachBioLabel)
        coachBioLabel.translatesAutoresizingMaskIntoConstraints = false
        coachBioLabel.topAnchor.constraint(equalTo: coachNameLabel.bottomAnchor, constant: 8).isActive = true
        coachBioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 48).isActive = true
        coachBioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -48).isActive = true
    }

    @objc func didSelectBabaCharacter() {
        DataStore.singleton.defaults.set("Baba", forKey: "coachName")
        DataStore.singleton.user.currentCoach = DataStore.singleton.getCurrentCoach()
        checkForSelectedCharacter()
    }
    
    @objc func didSelectPopsCharacter() {
        DataStore.singleton.defaults.set("Pops", forKey: "coachName")
        DataStore.singleton.user.currentCoach = DataStore.singleton.getCurrentCoach()
        checkForSelectedCharacter()
    }

    @objc func didSelectChadCharacter() {
        DataStore.singleton.defaults.set("Chad", forKey: "coachName")
        DataStore.singleton.user.currentCoach = DataStore.singleton.getCurrentCoach()
        checkForSelectedCharacter()
    }

}

extension HomeSettingsViewController {
    
    func setupHeaderView() {
        headerView.backgroundColor = Palette.salmon.color
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: viewHeight * (5/viewHeight)).isActive = true
        headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    
    func setupCancelSettingsButton() {
        self.dismissIcon.setBackgroundImage(#imageLiteral(resourceName: "IC_Quit-Black"), for: .normal)
        self.dismissIcon.alpha = 1
        self.view.addSubview(self.dismissIcon)
        self.dismissIcon.translatesAutoresizingMaskIntoConstraints = false
        self.dismissIcon.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16).isActive = true
        self.dismissIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        self.dismissIcon.widthAnchor.constraint(equalToConstant: 24).isActive = true
        self.dismissIcon.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.dismissIcon.addTarget(self, action: #selector(self.dismissSettingVC), for: .touchUpInside)
    }
    
    @objc func dismissSettingVC() {
        dismiss(animated: true, completion: nil)
    }

}
