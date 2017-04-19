
import UIKit
import CoreLocation
import MapKit

enum ShrinkStatus {
    case shrinked
    case expanded
}

class Place: NSObject, MKAnnotation {
    var title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, location: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = location
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
}

class BabaBreakView: UIView, CLLocationManagerDelegate {
    
    let viewModel = BabaBreakViewModel()
    
    //UI Properties
    let headerView = UIView()
    let topDividerView = UIView()
    let babaIconWindow = UIView()
    let babaIconView = UIImageView()
    let subjectLabel = UILabel()
    let babaNameLabel = UILabel()
    let toYouLabel = UILabel()
    let secondDividerView = UIView()
    let bodyTextLabel = UILabel()
    let backButton = UIButton()
    let mapView = MKMapView()
    let nextEmailBttn = UIButton()
    let location = CLLocationCoordinate2D()
    let locationManager = CLLocationManager()
    var mapShrinkStatus: ShrinkStatus = .shrinked
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        
        self.backgroundColor = .white
        setupHeaderView()
        setupNextEmailBttn()
        //setupBackButton()
        topDividerViewSetup()
        setupBabaIconWindow()
        setupBabaIconView()
        setupBabaNameLabel()
        setupToYouLabel()
        setupSecondDividerView()
        setupBodyOfText()
        setupMapView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewIsBeingDismissed), name: NSNotification.Name(rawValue: "coachBreakViewIsBeingDismissed"), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myCoord = locations[locations.count - 1]
        
        // get lat and long 
        let myLat = myCoord.coordinate.latitude
        let myLong = myCoord.coordinate.longitude
        let myCoord2D = CLLocationCoordinate2D(latitude: myLat, longitude: myLong)
        
        
        //set span
        let myLatDelta = 0.05
        let myLongDelta = 0.05
        let mySpan = MKCoordinateSpan(latitudeDelta: myLatDelta, longitudeDelta: myLongDelta)
        
        //set region 
        let myRegion = MKCoordinateRegion(center: myCoord2D, span: mySpan)
        
        //center map at this region
        mapView.setRegion(myRegion, animated: true)
        
        //do an mklocalsearch using the region
        searchRegion(region: myRegion)
        
    }
    
    func localSearch(coord2D: CLLocationCoordinate2D, queryKeyword: String) {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func searchRegion(region: MKCoordinateRegion) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = "cookies"
        searchRequest.region = region
        
        let searchResults = MKLocalSearch(request: searchRequest)
        searchResults.start { (response, error) in
            if let mapItems = response?.mapItems {
                for item in mapItems {
//                    let mapItem = MKMapItem(placemark: item.placemark)
//                    mapView.add
//                    mapView.add(placemark: item.placemark)
                    
                    //get address
                    guard let address = item.placemark.title else { continue }
                    //get title
                    guard let unwrappedName = item.name else { continue }
                    let locationName = unwrappedName
                    //get location coordinate
                    let locationCoord = item.placemark.coordinate
                    let locationAnnotation = Place(title: locationName, location: address, coordinate: locationCoord)
                    
                    
                    self.mapView.addAnnotation(locationAnnotation)
                    
                }
            }
        }
        
        
    }
    
    func viewIsBeingDismissed() {
    }
}

//UI Setup Extension
extension BabaBreakView {
    
    func setupHeaderView() {
        self.addSubview(headerView)
        headerView.backgroundColor = UIColor.white
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func setupBackButton() {
        headerView.addSubview(backButton)
        backButton.titleLabel?.text = "back"
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        backButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20).isActive = true
        
    }
    
    
    func topDividerViewSetup() {
        self.addSubview(topDividerView)
        topDividerView.backgroundColor = UIColor.lightGray
        
        topDividerView.translatesAutoresizingMaskIntoConstraints = false
        topDividerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        topDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        topDividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        topDividerView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        
    }
    
    func setupBabaIconWindow() {
        self.addSubview(babaIconWindow)
        babaIconWindow.backgroundColor = Palette.salmon.color
        let dimensionXY = CGFloat(60.0)
        babaIconWindow.translatesAutoresizingMaskIntoConstraints = false
        babaIconWindow.widthAnchor.constraint(equalToConstant: dimensionXY).isActive = true
        babaIconWindow.heightAnchor.constraint(equalToConstant: dimensionXY).isActive = true
        babaIconWindow.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        babaIconWindow.topAnchor.constraint(equalTo: topDividerView.bottomAnchor, constant: 10).isActive = true
        babaIconWindow.layer.cornerRadius = (dimensionXY / 2)
        babaIconWindow.layer.masksToBounds = true
    }
    
    func setupBabaIconView() {
        babaIconWindow.addSubview(babaIconView)
        babaIconView.image = #imageLiteral(resourceName: "IC_BABA")
        babaIconView.contentMode = .scaleAspectFit
        babaIconView.translatesAutoresizingMaskIntoConstraints = false
        babaIconView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        babaIconView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        babaIconView.centerXAnchor.constraint(equalTo: babaIconWindow.centerXAnchor).isActive = true
        babaIconView.bottomAnchor.constraint(equalTo: babaIconWindow.bottomAnchor, constant: 3).isActive = true
    }
    
    func setupBabaNameLabel() {
        self.addSubview(babaNameLabel)
        babaNameLabel.text = "From: Babushka"
        babaNameLabel.font = UIFont(name: "Avenir-Black", size: 14)
        
        babaNameLabel.translatesAutoresizingMaskIntoConstraints = false
        babaNameLabel.leadingAnchor.constraint(equalTo: babaIconWindow.trailingAnchor, constant: 10).isActive = true
        babaNameLabel.centerYAnchor.constraint(equalTo: babaIconWindow.centerYAnchor, constant: -10).isActive = true
    }
    
    func setupToYouLabel() {
        self.addSubview(toYouLabel)
        toYouLabel.text = "To: You"
        toYouLabel.font = UIFont(name: "Avenir-Light", size: 14)
        
        toYouLabel.translatesAutoresizingMaskIntoConstraints = false
        toYouLabel.topAnchor.constraint(equalTo: babaNameLabel.bottomAnchor).isActive = true
        toYouLabel.leadingAnchor.constraint(equalTo: babaNameLabel.leadingAnchor).isActive = true
    }
    
    func setupSecondDividerView() {
        self.addSubview(secondDividerView)
        secondDividerView.backgroundColor = UIColor.lightGray
        
        secondDividerView.translatesAutoresizingMaskIntoConstraints = false
        secondDividerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        secondDividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        secondDividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        secondDividerView.centerYAnchor.constraint(equalTo: babaIconWindow.bottomAnchor, constant: 10).isActive = true
    }
    
    func setupBodyOfText() {
        self.addSubview(bodyTextLabel)
        bodyTextLabel.text = "Hi Poopsik!! \n\nThis is babushka, you’re working too hard, checkout these GREAT places to get Cookies near you! \n\nDon’t starve yourself and overwork, take a walk outside or buy some cookies to give you more energy!"
        bodyTextLabel.font = UIFont(name: "Avenir-Light", size: 13)
        bodyTextLabel.numberOfLines = 10
        
        bodyTextLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyTextLabel.topAnchor.constraint(equalTo: secondDividerView.bottomAnchor, constant: 10).isActive = true
        bodyTextLabel.widthAnchor.constraint(equalTo: secondDividerView.widthAnchor, multiplier: 1).isActive = true
        bodyTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        
        
    }
    
    func setupMapView() {
        self.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.95).isActive = true
        mapView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        mapView.topAnchor.constraint(equalTo: bodyTextLabel.bottomAnchor, constant: 20).isActive = true
        mapView.bottomAnchor.constraint(equalTo: nextEmailBttn.topAnchor, constant: -10).isActive = true
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 40.7, longitude: -74)
        
    }
    
    
    func setupNextEmailBttn() {
        self.addSubview(nextEmailBttn)
        nextEmailBttn.backgroundColor = Palette.green.color
        nextEmailBttn.titleLabel?.font = UIFont(name: "Avenir-Black", size: 18)
        nextEmailBttn.addTarget(self, action: #selector(nextEmailBttnPrssd), for: .touchUpInside)
        nextEmailBttn.setTitle("Next Email from Baba", for: .normal)
        nextEmailBttn.translatesAutoresizingMaskIntoConstraints = false
        nextEmailBttn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        nextEmailBttn.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        nextEmailBttn.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        nextEmailBttn.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.08).isActive = true
        
    }
    
    func nextEmailBttnPrssd() {
        print("next email bttn pressed!")
    }
}

