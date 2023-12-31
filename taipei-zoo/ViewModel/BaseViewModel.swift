//
//  BaseViewModel.swift
//  taipei-zoo
//
//  Created by HSIEH YUN JU on 2023/6/17.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class BaseViewModel: NSObject {
    open var coordinator: AppCoordinator?
    public var disposeBag = DisposeBag()
}
