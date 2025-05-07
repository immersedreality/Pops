
import UIKit

//protocol to enable end break.
protocol BreakButtonDelegate: AnyObject {
    func endBreakBttnPressed()
    func moveToSessionEnded()
}

class SettingsViewController: UIViewController, DisplayBreakTimerDelegate {

    lazy var viewWidth: CGFloat = self.view.frame.width
    lazy var viewHeight: CGFloat = self.view.frame.height
    
    //reactive timer properties
    var settingsTimerCounter = 0 {
        didSet {
            settingsTotalTimerLabel.text = "\(formatTime(time: settingsTimerCounter)) left"
        }
    }
    weak var delegate: BreakButtonDelegate!
    
    //view properties
    let endBreakView = UIButton()
    let endBreakViewLabelLeft = UILabel()
    var breakTimerLabel = UILabel()
    let endSessionView = UIButton()
    let endSessionLabelLeft = UILabel()
    var settingsTotalTimerLabel = UILabel()

    let progressBar = UIView()
    var progressBarWidth = NSLayoutConstraint()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupEndSessionView()
        setupEndBreakView()
    }
    
    override func viewDidAppear(_ animated: Bool) {

        if let sessionCounter = DataStore.singleton.user.currentSession?.sessionTimerCounter {
            settingsTimerCounter = sessionCounter
            let breakTimerCounter = settingsTimerCounter - ((DataStore.singleton.user.currentSession!.cycleLength * DataStore.singleton.user.currentSession!.cyclesRemaining) - DataStore.singleton.user.currentSession!.sessionDifficulty.baseProductivityLength) + DataStore.singleton.user.currentSession!.sessionDifficulty.baseBreakLength
            breakTimerLabel.text = "\(formatTime(time: breakTimerCounter)) left"
        }
        
        breakTimerLabel.isHidden = false
        settingsTotalTimerLabel.isHidden = false
    }

    @objc func endSessionBttnPressed() {
        endSessionView.backgroundColor = Palette.grey.color
        DataStore.singleton.user.currentSession?.sessionTimer.invalidate()
        delegate.moveToSessionEnded()
    }
    
    @objc func endBreakBttnPressed() {
        endBreakView.backgroundColor = Palette.darkPurple.color
        delegate.endBreakBttnPressed()
    }

}


//view setups
extension SettingsViewController {

    func setupEndSessionView() {
        view.addSubview(endSessionView)
        endSessionView.backgroundColor = Palette.lightGrey.color
        endSessionView.translatesAutoresizingMaskIntoConstraints = false
        endSessionView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
        endSessionView.heightAnchor.constraint(equalToConstant: viewHeight * (50/667)).isActive = true
        endSessionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        endSessionView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endSessionView.layer.cornerRadius = 2
        endSessionView.addTarget(self, action: #selector(endSessionBttnPressed), for: .touchUpInside)
        
        endSessionView.addSubview(endSessionLabelLeft)
        endSessionLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 13)
        endSessionLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endSessionLabelLeft.text = "end my session"
        endSessionLabelLeft.textColor = Palette.darkText.color
        
        endSessionLabelLeft.leadingAnchor.constraint(equalTo: endSessionView.leadingAnchor, constant: viewWidth * (15 / 375)).isActive = true
        endSessionLabelLeft.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
        
        endSessionView.addSubview(settingsTotalTimerLabel)
        settingsTotalTimerLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        settingsTotalTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsTotalTimerLabel.text = "left"
        settingsTotalTimerLabel.textColor = Palette.darkText.color
        settingsTotalTimerLabel.textAlignment = .right
        settingsTotalTimerLabel.isHidden = true
        
        settingsTotalTimerLabel.trailingAnchor.constraint(equalTo: endSessionView.trailingAnchor, constant: -viewWidth * (15 / 375)).isActive = true
        settingsTotalTimerLabel.centerYAnchor.constraint(equalTo: endSessionView.centerYAnchor, constant: 0).isActive = true
    }
    
    func setupEndBreakView() {
        view.addSubview(endBreakView)
        endBreakView.backgroundColor = Palette.purple.color
        endBreakView.translatesAutoresizingMaskIntoConstraints = false
        endBreakView.widthAnchor.constraint(equalToConstant: viewWidth * (300 / 375)).isActive = true
        endBreakView.heightAnchor.constraint(equalToConstant: viewHeight * (50 / 667)).isActive = true
        endBreakView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        endBreakView.bottomAnchor.constraint(equalTo: endSessionView.topAnchor, constant: -viewHeight * (20 / 667)).isActive = true
        endBreakView.layer.cornerRadius = 2
        endBreakView.addTarget(self, action: #selector(endBreakBttnPressed), for: .touchUpInside)
    
        
        endBreakView.addSubview(endBreakViewLabelLeft)
        endBreakViewLabelLeft.font = UIFont(name: "Avenir-Heavy", size: 13)
        endBreakViewLabelLeft.translatesAutoresizingMaskIntoConstraints = false
        endBreakViewLabelLeft.text = "end my break"
        endBreakViewLabelLeft.textColor = UIColor.white
        
        endBreakViewLabelLeft.leadingAnchor.constraint(equalTo: endBreakView.leadingAnchor, constant: viewWidth * (15 / 375)).isActive = true
        endBreakViewLabelLeft.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
        
        endBreakView.addSubview(breakTimerLabel)
        breakTimerLabel.font = UIFont(name: "Avenir-Heavy", size: 13)
        breakTimerLabel.translatesAutoresizingMaskIntoConstraints = false
        breakTimerLabel.text = "left"
        breakTimerLabel.textColor = UIColor.white
        breakTimerLabel.textAlignment = .right
        breakTimerLabel.isHidden = true
        
        breakTimerLabel.trailingAnchor.constraint(equalTo: endBreakView.trailingAnchor, constant: -viewWidth * (15 / 375)).isActive = true
        breakTimerLabel.centerYAnchor.constraint(equalTo: endBreakView.centerYAnchor, constant: 0).isActive = true
    }
    
}

extension SettingsViewController {
    
    //helper method
    func formatTime(time: Int) -> String {
        if time >= 3600 {
            let hours = time / 3600
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
        } else if time >= 60 {
            
            let minutes = time / 60 % 60
            let seconds = time % 60
            return String(format:"%02i:%02i", minutes, seconds)
            
        } else {
            let seconds = time % 60
            return String(format:"%02i", seconds)
        }
    }
}





