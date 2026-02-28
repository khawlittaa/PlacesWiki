//
//  PlacesWikiApp.swift
//  PlacesWiki
//
//  Created by khaoula hafsia on 26/02/2026.
//

import SwiftUI

@main
struct PlacesWikiApp: App {
    var body: some Scene {
        WindowGroup {
            WikiPlacesFactory.makeMainView()
        }
    }
}
