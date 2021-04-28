//
//  EventCell.swift
//  EventosApp
//
//  Created by Lucas Santiago on 24/04/21.
//

import UIKit

class EventCell: UITableViewCell {
    lazy var eventImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    func configureViews() {
        contentView.addSubview(eventImage)
        contentView.addSubview(fullnameLabel)
        
        eventImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
        eventImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        eventImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        eventImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        fullnameLabel.leadingAnchor.constraint(equalTo: eventImage.trailingAnchor, constant: 16).isActive = true
        fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
        fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(_ event: Event){
        self.fullnameLabel.text = event.title
        self.fullnameLabel.numberOfLines = 0
        
        self.eventImage.image = UIImage(systemName: "nosign")
        
        if let image = Cache.shared.object(forKey: "\(event.id)" as NSString) {
            self.eventImage.image = image
            return
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


class Cache {
    static let shared = NSCache<NSString,UIImage>()
}
