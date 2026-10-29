//
//  AppRouter.swift
//  BookAlchemist
//
//  Created by Student 1 on 2026-10-21.
//

import SwiftUI
import Combine

// Using an enum to keep navigation destinations clean
enum AppRoute: Hashable {
    case bookDetails
    case updateProgress
    case challenges
    case reader(Book)
}

class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
