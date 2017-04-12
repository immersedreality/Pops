import Foundation
import UIKit

final class DataStore {
    
    static let singleton = DataStore()
    
    let defaults = UserDefaults.standard
    var user: User!
    
    private init(){
        let userName = defaults.value(forKey: "username") as? String ?? nil
        let totalProps = defaults.value(forKey: "totalProps") as? Int ?? 0
        let unlockedCoaches = defaults.value(forKey: "unlockedCoaches") as? [String] ?? ["Pops"]
        let appNames = defaults.value(forKey: "appNames") as? [String] ?? ["Messages", "Email", "Facebook"]
        self.user = User(userName: userName, totalProps: totalProps, unlockedCoachNames: unlockedCoaches, appNames: appNames, currentCoach: getCurrentCoach(), currentSession: nil)
    }
    
    func getCurrentCoach() -> Coach {
        let coachName = defaults.value(forKey: "coachName") as? String ?? "Pops"
        let currentCoach = generateCoachFrom(name: coachName)
        return currentCoach
    }
    
    private func generateCoachFrom(name coachName: String) -> Coach {
        switch coachName {
        case "Pops":
            return generatePops()
        case "Baba":
            return generateBaba()
        case "Chad":
            return generateChad()
        default:
            return generatePops()
        }
    }
}

private extension DataStore {
    func generatePops() -> Coach {
        let name = "Pops"
        let icon = UIImage(named: "IC_POPS")
        let difficulty = DifficultySetting.standard
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "I’ll make sure you are super productive today. How long would you like to stay productive for?")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Lock your phone now.", "I’ll tell you to take a break when the timer hits 0. Don’t even think about touching your phone before then.")
        ]
        let breakStatements = [
            ("Congrats on your first 5 minute break!", "Do whatever! I thought you may want to catch up on texts, email, and Facebook, so I gave you easy access to those apps below. If you have nothing else to do, I can entertain you."),
            ("Congrats!", "Enjoy your break!")
        ]
        let endSessionStatements = [
            ("Congrats!", "See you soon!")
        ]
        let pops = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            breakStatements: breakStatements,
            endSessionStatements: endSessionStatements,
            breakView: PopsBreakView())
        return pops
    }
    
    
    func generateBaba() -> Coach {
        let name = "Baba"
        let icon: UIImage? = nil
        let difficulty = DifficultySetting.easy
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "Make me proud by putting in a hard day's work!")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Lock your phone!", "Keep working, bubby!")
        ]
        let breakStatements = [
            ("Congrats!", "Enjoy your break!")
        ]
        let endSessionStatements = [
            ("Congrats!", "See you soon!")
        ]
        let baba = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            breakStatements: breakStatements,
            endSessionStatements: endSessionStatements,
            breakView: BabaBreakView())
        return baba
    }
    
    
    func generateChad() -> Coach {
        let name = "Chad"
        let icon: UIImage? = nil
        let difficulty = DifficultySetting.hard
        let tapStatements = [
            ("Hey!", "Hands off, buddy!")
        ]
        let introStatements = [
            ("Hey there, I'm Pops!", "Make me proud by putting in a hard day's work!")
        ]
        let setSessionStatements = [
            [("Only an hour?", "Seems like you could do better.")],
            [("Two hours.", "That's respectable.")],
            [("Three hours!", "Good for you!")],
            [("Four hours, huh?", "I'm Impressive!")],
            [("Five hours?", "You're really going for it today!")],
            [("Hmmmmm...", "As long as you take your breaks, this should be okay.")],
            [("Seven hours!", "What an odd choice!")],
            [("Dear lord!", "Don't hurt yourself, sonny!")],
            ]
        let productivityStatements = [
            ("Lock your phone!", "Keep working, bubby!")
        ]
        let breakStatements = [
            ("Congrats!", "Enjoy your break!")
        ]
        let endSessionStatements = [
            ("Congrats!", "See you soon!")
        ]
        let chad = Coach(
            name: name,
            icon: icon,
            difficulty: difficulty,
            tapStatements: tapStatements,
            introStatements: introStatements,
            setSessionStatements: setSessionStatements,
            productivityStatements: productivityStatements,
            breakStatements: breakStatements,
            endSessionStatements: endSessionStatements,
            breakView: ChadBreakView())
        return chad
    }
}