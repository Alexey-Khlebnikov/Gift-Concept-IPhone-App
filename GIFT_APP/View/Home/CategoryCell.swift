import UIKit

class CategoryCell: BaseCell {
    
    let endPoint = "\(Setting.serverURL)/assets/img/category/"
    
    var category: Category? {
        didSet {
            name.text = category?.name
            loadImages()
        }
    }
    
    let backgroundImageView: URLImageView = {
        let imageView = URLImageView()
        imageView.layer.cornerRadius = 15.0
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        imageView.clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let thumbnailImageView: URLImageView = {
        let imageView = URLImageView()
        imageView.contentMode = .scaleAspectFit
            
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let name: UILabel = {
        let name = UILabel()
        name.text = "Cloths"
        name.font = name.font.withSize(16)
        
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    let detailContainerView: BezierView = {
        let detailView = BezierView()
        detailView.backgroundColor = .white
        detailView.distance = 50.0
        detailView.radius = 15.0
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        return detailView
    }()
    
    override func setupViews() {
        super.setupViews()
        shadow(left: 8.0, top: 8.0, feather: 15, color: .black, opacity: 0.1)
        
        addSubview(backgroundImageView)
        addSubview(detailContainerView)
        addSubview(thumbnailImageView)
        addSubview(name)
        
        let detailWidth:CGFloat  = 190.0
        let thumbSize:CGFloat = 20.0
        let nameHeight:CGFloat = 20.0
        let dis:CGFloat = 8.0
        let offsetX1 = (detailWidth - thumbSize) / 2
        let offsetY1 = (frame.height - thumbSize - nameHeight - dis) / 2;
        
        addConstraintsWithFormat(format: "H:|-20-[v0]-(-65)-[v1(\(detailWidth))]-20-|", views: backgroundImageView, detailContainerView)
        addConstraintsWithFormat(format: "H:[v0(\(thumbSize))]-\(offsetX1)-|", views: thumbnailImageView)
        addConstraint(NSLayoutConstraint(item: name, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: .equal, toItem: thumbnailImageView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: backgroundImageView)
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: detailContainerView)
        addConstraintsWithFormat(format: "V:|-\(offsetY1+5)-[v0(\(thumbSize))]-\(dis)-[v1]-(\(offsetY1-5))-|", views: thumbnailImageView, name)
    }
    
    func loadImages() {
        if let imageURL = category?.imageURL {
            self.backgroundImageView.fromURL(urlString: endPoint + imageURL)
        }
        if let iconURL = category?.iconURL {
            self.thumbnailImageView.fromURL(urlString: endPoint + iconURL)
        }
    }
    
}
