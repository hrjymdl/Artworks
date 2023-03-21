
import UIKit

class TableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Galvji", size: 15)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let artworkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
    
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(artworkImageView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artworkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artworkImageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor, multiplier: 1.0, constant: 0)
        ])
    }
    
}

