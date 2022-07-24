//
//  NextViewController.swift
//  RxSwift_Practice_2
//
//  Created by anies1212 on 2022/07/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxOptional
import RxWebKit
import WebKit

class NextViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWebView()
    }
    
    private func setUpWebView(){
        let loadingObsevable = webView.rx.loading
            .share()
        
        loadingObsevable
            .map { value in
                print("value:\(value)")
                return !value
            }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.isHidden)
            .disposed(by: disposeBag)
        
        loadingObsevable
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        webView.rx.title
            .filterNil()
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        webView.rx.estimatedProgress
            .map { return Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: progressView.rx.progress)
            .disposed(by: disposeBag)
        
        guard let url = URL(string: "https://www.google.com/?hl=ja") else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    

}
