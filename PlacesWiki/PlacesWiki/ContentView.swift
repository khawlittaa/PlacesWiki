//  ContentView1.swift
//  PlacesWiki


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LocationsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading locations...")
                            .accessibilityLabel("Loading locations from server")
                    }

                    if let error = viewModel.errorMessage {
                        Label(error, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.red)
                    }

                    customLocationSection

                    locationsList
                }
                .padding()
            }
            .navigationTitle("Places Wiki")
            .refreshable { await viewModel.loadLocations() }
            .task { await viewModel.loadLocations() }
        }
    }

    private var customLocationSection: some View {
        Section {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Add Custom Location")
                        .font(.headline)
                    HStack {
                        TextField("Latitude", text: $viewModel.customLatInput)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                        TextField("Longitude", text: $viewModel.customLongInput)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    }
                }
                Button("Add") { viewModel.addCustomLocation() }
                    .buttonStyle(.borderedProminent)
            }
        } header: {
            Text("Custom Coordinates")
        }
    }

    private var locationsList: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            ForEach(viewModel.locations, id: \.self) { location in
                Button {
                    Task { await viewModel.openWikipediaPlace(for: location) }
                } label: {
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(location.name ?? "Unnamed Location")
                                .font(.headline)
                            Text("lat:\(location.lat, specifier: "%.4f"), long:\(location.long, specifier: "%.4f")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Open Wikipedia Places for \(location.name ?? "location") at lat:\(location.lat), long:\(location.long)")
            }
        }
    }
}

#Preview {
    ContentView()
}

