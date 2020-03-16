//
//  NewsViewController.swift
//  NewsAPI
//
//  Created by Cuong Do Hung on 3/14/20.
//  Copyright © 2020 Cuong Do Hung. All rights reserved.
//
/* The base class for HeadlineVC & CustomeNewsVC */
import UIKit
import RxSwift
import RxCocoa
class NewsViewController: UIViewController, NewsAPIRequestDelegate {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView?
    var newsModelView: NewsViewModel?
    private let disposeBag = DisposeBag() // used to release dispose in RxSwift
    var reusedTableViewCellIdNews = "ReusedCellIdNews"
    var reusedTableViewCellIdLoad = "ReusedCellIdLoad"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsModelView = NewsViewModel(delegate: self)
        // add pull refresh to table view
        configureRefreshControl()
        // integrate with rxswift
        configureRxSwift(with: newsModelView)
    }
    func configureRefreshControl () {
       // Add the refresh control to your UIScrollView object.
       tableView?.refreshControl = UIRefreshControl()
       tableView?.refreshControl?.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    // MARK: - config the rxswift with controllers
    func configureRxSwift(with newsViewModel: NewsViewModel?) {
        guard let viewModel = newsViewModel else {return}
        let queryingFirstPageObserver = BehaviorRelay<NewsViewModel>(value: viewModel)
        queryingFirstPageObserver.value.isQueryingFirstPage.asObservable()
            .subscribe(onNext: {[weak self] querying in
                // show/hide activity indicator, table view
                self?.activityIndicatorView?.isHidden = !querying
                // start animation
                if querying {
                    self?.activityIndicatorView?.startAnimating()
                }else { // stop animation
                    self?.activityIndicatorView?.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    // triggered when pull & refresh
    @objc func handleRefreshControl() {
        newsModelView?.loadedPage = 0
        // Dismiss the refresh control.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[unowned self] in
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
    // implement NewsAPIRequestDelegate method to reload tableview
    func newsAPIRequestSuccess() {
        // increase page
        newsModelView?.loadedPage += 1
        // refresh table view
        tableView?.reloadData()
    }
    func newsAPIRequestFailed(error: NSError) {
        // show error alert
        RouteManager.showAlert(message: error.localizedDescription, parrent: self)
    }
}
// MARK: --implement tableview delegate, datasource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    // total number of row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModelView?.getNumberOfRow() ?? 0
    }
    // initiate a cell at indexpath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsModelView = newsModelView else { return UITableViewCell ()}
        let numOfRow = newsModelView.getNumberOfRow()
        if let articles = newsModelView.articles, indexPath.row < articles.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: reusedTableViewCellIdNews ) as? NewsCell, let article = newsModelView.articles?[indexPath.row]{
                cell.update(article: article)
                return cell
            }
        }else if indexPath.row < numOfRow { // for load more row
            if let cell = tableView.dequeueReusableCell(withIdentifier: reusedTableViewCellIdLoad) as? LoadCell {
                cell.newsViewModel = newsModelView
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    // a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let articles = newsModelView?.articles, indexPath.row < articles.count {
            let article = articles[indexPath.row]
            if let detailVC = RouteManager.getViewControllerWithId(ViewControllerIds.detailVC) as? DetailViewController {
                detailVC.article = article
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
