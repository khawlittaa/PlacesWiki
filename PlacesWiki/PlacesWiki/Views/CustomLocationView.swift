//  CustomLocationView.swift
//  PlacesWiki


import SwiftUI

struct CustomLocationView: View {
    @ObservedObject var viewModel: CustomLocationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: PlacesWikiSpacing.s) {
            Text(viewModel.titleText)
                .font(PlacesWikiFonts.headline)
                .foregroundStyle(PlacesWikiColors.textPrimary)
            
            HStack(spacing: PlacesWikiSpacing.s) {
                
                VStack(alignment: .leading, spacing: PlacesWikiSpacing.xs) {
                    Text(viewModel.latitudeLabelText)
                        .font(PlacesWikiFonts.caption)
                        .foregroundStyle(PlacesWikiColors.textSecondary)
                    TextField("xx.xxx", text: $viewModel.latitudeInput)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
                
                VStack(alignment: .leading, spacing: PlacesWikiSpacing.xs) {
                    Text(viewModel.longitudeLabelText)
                        .font(PlacesWikiFonts.caption)
                        .foregroundStyle(PlacesWikiColors.textSecondary)
                    TextField("xx.xxx", text: $viewModel.longitudeInput)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
            }
            
            Button(viewModel.addButtonText) {
                viewModel.addTapped()
            }
            .font(PlacesWikiFonts.button)
            .foregroundStyle(PlacesWikiColors.surface)
            .padding(.horizontal, PlacesWikiSpacing.s)
            .padding(.vertical, PlacesWikiSpacing.xs)
            .background(PlacesWikiColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: PlacesWikiRadius.s))
        }
        .padding(.horizontal, PlacesWikiSpacing.s)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    CustomLocationView(
        viewModel: CustomLocationViewModel { _ in }
    )
}
