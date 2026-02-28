//  DesignSystem.swift
//  PlacesWiki

import SwiftUI

public enum PlacesWikiColors {
    public static let primary = Color.blue
    public static let secondary = Color.gray
    public static let background = Color(.systemBackground)
    public static let surface = Color(.systemGroupedBackground)
    public static let error = Color.red
    public static let success = Color.green
    public static let textPrimary = Color.primary
    public static let textSecondary = Color.secondary
}

public enum PlacesWikiFonts {
    public static let title1 = Font.largeTitle
    public static let title2 = Font.title
    public static let title3 = Font.title2
    public static let headline = Font.headline
    public static let body = Font.body
    public static let caption = Font.caption
    public static let button = Font.body.bold()
}

public enum PlacesWikiSpacing {
    public static let xs = CGFloat(4)
    public static let s = CGFloat(8)
    public static let m = CGFloat(16)
    public static let l = CGFloat(24)
    public static let xl = CGFloat(32)
    public static let xxl = CGFloat(48)
}

public enum PlacesWikiRadius {
    public static let s = CGFloat(8)
    public static let m = CGFloat(12)
    public static let l = CGFloat(16)
}
