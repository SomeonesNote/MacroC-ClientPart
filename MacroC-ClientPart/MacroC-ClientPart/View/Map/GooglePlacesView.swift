//
//  GooglePlacesView.swift
//  MacroC-ClientPart
//
//  Created by Kimdohyun on 2023/10/05.
//

import SwiftUI
import GooglePlaces

struct GooglePlacesSearchView: UIViewControllerRepresentable {
    @Binding var address: String
    

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UISearchController {
        let resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = context.coordinator

        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController

        return searchController
    }

    func updateUIViewController(_ uiViewController: UISearchController, context: Context) {}

    class Coordinator: NSObject, GMSAutocompleteResultsViewControllerDelegate {
        var parent: GooglePlacesSearchView

        init(_ parent: GooglePlacesSearchView) {
            self.parent = parent
        }

        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
            parent.address = place.formattedAddress ?? ""
            resultsController.dismiss(animated: true, completion: nil)
        }

        func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    GooglePlacesSearchView(address: .constant(""))

}
