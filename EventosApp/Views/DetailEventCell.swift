//
//  DetailEventCell.swift
//  EventosApp
//
//  Created by Lucas Santiago on 25/04/21.
//

import UIKit
import SnapKit
import MapKit

protocol DetailEventCellDelegate: AnyObject {
    func checkIn(eventId: String?, name: String?, email: String?)
    func share(share: Event?)
}

class DetailEventCell: UITableViewCell {
    weak var delegate: DetailEventCellDelegate?
    var event: Event?
    
    private let eventTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private let eventDescriptionLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    var eventDateTitleLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Data:"
        label.textColor = .black
        return label
    }()
    
    var eventDateLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    var eventPriceTitleLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Preço:"
        label.textColor = .black
        return label
    }()
    
    var eventPriceLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    var eventNameTitleLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "Nome:"
        label.textColor = .black
        return label
    }()
    
    var eventNameTextField : UITextField =  {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .left
        textField.textColor = .black
        textField.placeholder = "Digite seu nome aqui pro Check-In"
        textField.borderStyle = .roundedRect
        textField.isUserInteractionEnabled = true
        return textField
    }()
    
    var eventEmailLabel : UITextField =  {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .left
        textField.textColor = .black
        textField.placeholder = "Digite seu email aqui pro Check-In"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var eventEmailTitleLabel : UILabel =  {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.text = "E-mail:"
        label.textColor = .black
        return label
    }()
    
    private let eventImage : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let createCheckInButton: UIButton = {
        let btn = Utils.buildCornedButton(title: "Check-in")
        btn.backgroundColor = .red
        btn.isUserInteractionEnabled = true
        btn.showsTouchWhenHighlighted = true
        return btn
    }()
    
    private let createShareButton: UIButton = {
        let btn = Utils.buildCornedButton(title: "Compartilhar")
        btn.backgroundColor = .red
        btn.isUserInteractionEnabled = true
        btn.showsTouchWhenHighlighted = true
        return btn
    }()
    
    private let createMap: MKMapView = {
        let mkMapView = MKMapView()
        mkMapView.mapType = .standard
        mkMapView.isZoomEnabled = true
        mkMapView.isScrollEnabled = true
        return mkMapView
    }()
    
    @objc func checkIn(){
        delegate?.checkIn(eventId: event?.id, name: eventNameTextField.text, email: eventEmailLabel.text)
    }
    
    @objc func share(){
        delegate?.share(share: event)
        return
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        createCheckInButton.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        createShareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    func configureViews() {
        
        let stackView2 = UIStackView(arrangedSubviews: [eventDateTitleLabel,eventDateLabel,eventPriceTitleLabel,eventPriceLabel])
        stackView2.distribution = .equalSpacing
        stackView2.axis = .horizontal
        stackView2.spacing = 5
        addSubview(stackView2)
        stackView2.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        let stackView3 = UIStackView(arrangedSubviews: [eventNameTitleLabel,eventNameTextField])
        stackView3.distribution = .fillProportionally
        stackView3.axis = .horizontal
        stackView3.spacing = 0
        stackView3.alignment = .fill
        addSubview(stackView3)
        stackView3.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        eventNameTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        let stackView4 = UIStackView(arrangedSubviews: [eventEmailTitleLabel,eventEmailLabel])
        stackView4.distribution = .fillProportionally
        stackView4.axis = .horizontal
        stackView4.spacing = 0
        stackView4.alignment = .fill
        addSubview(stackView4)
        stackView4.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        eventEmailTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(70)
        }
        
        let stackView5 = UIStackView(arrangedSubviews: [createCheckInButton, createShareButton])
        stackView5.distribution = .equalSpacing
        stackView5.axis = .horizontal
        stackView5.spacing = 20
        addSubview(stackView5)
        stackView5.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        createCheckInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(180)
        }
        
        createShareButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(180)
        }
        
        eventImage.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(200)
        }
        
        let stackView = UIStackView(arrangedSubviews: [eventImage, eventTitleLabel,eventDescriptionLabel,stackView2, stackView3, stackView4, stackView5, createMap])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 20
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }

        createMap.snp.makeConstraints { make in
            make.height.equalTo(600)
            make.width.equalTo(500)
        }
    }
    
    func configure(_ event: Event){

        self.event = event
        self.selectionStyle = .none
        contentView.isUserInteractionEnabled = true
        let pin1 = MapPin(title: "Evento", locationName: event.title, coordinate:    CLLocationCoordinate2D.init(latitude: event.latitude, longitude: event.longitude))
        let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        self.createMap.setRegion(coordinateRegion, animated: true)
        self.createMap.addAnnotations([pin1])
        
        self.eventTitleLabel.text = event.title
        self.eventTitleLabel.numberOfLines = 0
        self.eventDescriptionLabel.text = event.description
        self.eventDescriptionLabel.numberOfLines = 0
        self.eventDescriptionLabel.lineBreakMode = .byWordWrapping
        
        let myTimeInterval = TimeInterval(event.date)
        let date = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        if let yourDate = formatter.date(from: myString){
            formatter.dateFormat = "dd/MM/yyyy"
            let dateString = formatter.string(from: yourDate)
            self.eventDateLabel.text = "\(dateString)"
        }
        
        self.eventPriceLabel.text = "\("R$ " + Utils.formatDoubleString(event.price))"
        
        self.eventImage.image = UIImage(systemName: "nosign")
        
        if let image = Cache.shared.object(forKey: "\(event.id)" as NSString) {
            self.eventImage.image = image
        } else if let urlPhoto = event.url {
            
            Cache.shared.removeObject(forKey: "\(event.id)" as NSString)
            
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: urlPhoto)
                    let image = UIImage(data: data) ?? UIImage(systemName: "nosign")!
                    Cache.shared.setObject(image, forKey: "\(event.id)" as NSString)
                    DispatchQueue.main.async {
                        self.eventImage.image = image
                    }
                    
                } catch _ {}
            }
        }
    }
}
