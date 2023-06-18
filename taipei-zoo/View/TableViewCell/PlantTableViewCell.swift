//
//  PlantTableViewCell.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/18.
//

import UIKit
import RxSwift
import RxCocoa

class PlantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var plantImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    var plantModel: PlantUIModel?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupUI() {
        
        titleName.text = plantModel?.name
        
        let url = plantModel!.picURL.replacingOccurrences(of: "http://", with: "https://")
        guard let imageURL = URL(string: url) else { return }
        
        let imageObservable = URLSession.shared.rx.data(request: URLRequest(url: imageURL))
            .flatMap { data -> Observable<UIImage?> in
                var image: UIImage?
                image = UIImage(data: data)
                image = image?.resize(to: CGSize(width: self.plantImageView.bounds.width, height: self.plantImageView.bounds.height))
                return .just(image)
            }
            .observe(on: MainScheduler.instance)
            .catch { error -> Observable<UIImage?> in
                print("Image download error: \(error)")
                return .just(UIImage(systemName: "photo.fill"))
            }

        // 將下載的圖片綁定到imageView
        imageObservable
            .bind(to: plantImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
