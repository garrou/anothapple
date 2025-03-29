//
//  Datasoure.swift
//  anothapp
//
//  Created by Adrien Garrouste on 25/03/2025.
//

import Foundation

class Datasource {
    
    static var mockSerieInfos = SerieInfos(seasons: [], time: 0, episodes: 0)
    
    static var mockSerie = Serie(id: 1, title: "Test", poster: "https://picsum.photos/200", kinds: ["Action"], favorite: false, duration: 45, addedAt: Date(), country: "France", watch: true, seasons: 2)
    
    static var mockImages = ["https://picsum.photos/200", "https://picsum.photos/201", "https://picsum.photos/202"]
    
    static var mockDiscoverSerie = ApiSerie(id: 33104, title: "Daredevil: Born Again", poster: "https://pictures.betaseries.com/fonds/poster/1b03b1f37e10c1eb8d675f869bc4adcd.jpg", kinds: ["Action", "Drame"],  duration: 59, country: "États-Unis", synopsis: "Aveugle depuis ses neuf ans à la suite d'un accident, Matt Murdock bénéficie d'une acuité extraordinaire de ses autres sens. Avocat le jour, il devient le super-héros Daredevil lorsque la nuit tombe, afin de lutter contre l’injustice à New York, plus particulièrement dans le quartier de Hell's Kitchen, corrompu par la criminalité depuis sa reconstruction après l'attaque des Chitauris (lors des événements du film Avengers).", seasons: 1, episodes: 6, network: "Disney+", note: 4.37931, status: "En cours", creation: "2025", platforms: [Platform(name: "Disney+", logo: "https://pictures.betaseries.com/platforms/246.jpg"), Platform(name: "Canal+ Ciné Séries", logo: "https://pictures.betaseries.com/platforms/278.jpg")])
}
