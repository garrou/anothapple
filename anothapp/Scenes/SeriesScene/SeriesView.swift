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
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isSearchFocused ? .primary : .secondary, lineWidth: 1)
                        )
                        .padding(.horizontal, 10)
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
                    .padding()
                }
                
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
                            VStack {
                                ImageCardView(url: serie.poster)
                                Text(serie.title).font(.headline)
                            }
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
                            
                            // Tabs
                            Picker("", selection: $viewModel.selectedFilterTab) {
                                Image(systemName: "theatermasks").tag(FilterTab.kinds)
                                Image(systemName: "flag").tag(FilterTab.countries)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            
                            TabView(selection: $viewModel.selectedFilterTab) {
                                
                                List {
                                    // TODO
                                }
                                .tag(FilterTab.kinds)
                                
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
                                .listStyle(PlainListStyle())
                                .tag(FilterTab.countries)
                                .onAppear {
                                    viewModel.loadCountries()
                                }
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
        .navigationTitle("Mes séries")
        .padding(.vertical, 10)
        .onReceive(StateManager.shared.$hasLoaded) { newValue in
            Task {
                if !newValue { return }
                await viewModel.loadSeries()
            }
        }
    }
}

#Preview {
    SeriesView(viewModel: .mock)
}

