//
//  SeriesPageView.swift
//  anothapp
//
//  Created by Adrien Garrouste on 24/03/2025.
//

import SwiftUI

struct SeriesView: View {
    
    @StateObject var viewModel: SeriesViewModel
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            ScrollView {
                
                HStack {
                    TextField("Titre de la série", text: $viewModel.titleSearch)
                        .padding(.all, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSearchFocused ? .primary : .secondary, lineWidth: 1)
                        )
                        .focused($isSearchFocused)
                        .onChange(of: viewModel.titleSearch) {
                            Task {
                                await viewModel.loadSeries()
                            }
                        }
                    
                    Button(action: { viewModel.isFiltersOpened.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.system(size: 20, weight: .regular))
                    }
                }
                .padding(.horizontal, 4)
                
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    Text("\(viewModel.series.count) séries")
                        .font(.subheadline)
                    
                    GridView(items: viewModel.series, columns: 2) { serie in
                        Button(action: {
                            viewModel.routeToSerieDetail(serie: serie)
                        })
                        {
                            CardView(picture: serie.poster, text: serie.title)
                        }
                    }
                }
            }
            
            // Right drawer
            if viewModel.isFiltersOpened {
                ZStack {
                    Color.primary.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                viewModel.isFiltersOpened.toggle()
                            }
                        }
                    
                    HStack {
                        
                        Spacer() // Drawer to the right
                        
                        VStack {
                            
                            Picker("", selection: $viewModel.selectedFilterTab) {
                                Image(systemName: "theatermasks").tag(FilterTab.kinds)
                                Image(systemName: "flag").tag(FilterTab.countries)
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            
                            TabView(selection: $viewModel.selectedFilterTab) {
                                
                                KindsView(viewModel: viewModel).tag(FilterTab.kinds)
                                
                                CountriesView(viewModel: viewModel).tag(FilterTab.countries)
                            }
                        }
                        .frame(width: 300)
                        .background(Color(UIColor.systemBackground))
                        .edgesIgnoringSafeArea(.all)
                    }
                    .transition(.move(edge: .trailing))
                }.zIndex(10)
            }
        }
        .padding(.vertical, 10)
        .onReceive(StateManager.shared.$hasLoaded) { newValue in
            Task {
                if !newValue { return }
                await viewModel.loadSeries()
            }
        }
    }
}

private struct KindsView: View {
    
    @StateObject var viewModel: SeriesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.kinds, id: \.value) { kind in
                HStack {
                    Text(kind.name)
                    
                    Spacer()
                    
                    if viewModel.isKindSelected(kind) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.primary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        await viewModel.selectKind(kind)
                    }
                }
            }
        }
        .listStyle(.plain)
        .task {
            await viewModel.loadKinds()
        }
    }
}

private struct CountriesView: View {
    
    @StateObject var viewModel: SeriesViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.countries, id: \.self) { country in
                HStack {
                    Text(country)
                    
                    Spacer()
                    
                    if viewModel.isCountrySelected(country) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.primary)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    Task {
                        await viewModel.selectCountry(country)
                    }
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            viewModel.loadCountries()
        }
    }
}

#Preview {
    SeriesView(viewModel: .mock)
}

