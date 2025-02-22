//
//  HomeViewController.swift
//  ibiHomeProject
//
//  Created by Nikita Koniukh on 21/02/2025.
//

import UIKit
import Combine
import SwiftData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: HomeViewModel?
    private var cancellables = Set<AnyCancellable>()
    var container: ModelContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = HomeViewModel()
        setupTableView()
        setupBindings()
        viewModel?.fetchProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupBindings() {
        viewModel?.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func presentDetailsViewController(with product: Product?, indexPath: IndexPath) {
        let sb = UIStoryboard(name: "DetailsViewController", bundle: nil)
        if let product, let detailsViewController = sb.instantiateInitialViewController() as? DetailsViewController {
            detailsViewController.product = product
            self.navigationController?.present(detailsViewController, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.products.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as? ProductTableViewCell
        cell?.delelegate = self
        let product = viewModel?.products[indexPath.row]
        let isSaved = viewModel?.isProductSaved(product) == true
        cell?.configure(with: product, saved: isSaved)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = viewModel?.products[indexPath.row]
        presentDetailsViewController(with: product, indexPath: indexPath)
    }
}

extension HomeViewController: ProductTableViewCellDelegate {
    func favoriteSelected(for product: Product?) {
        viewModel?.saveProduct(product)
    }
    
    func favoriteDeSelected(for product: Product?) {
        viewModel?.deleteProduct(product)
    }
}
