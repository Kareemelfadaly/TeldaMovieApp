//
//  URLImage.swift
//  TeldaMovieApp
//
//  Created by Kareem Elfadaly on 24/04/2025.
//


import SwiftUI
import Combine

struct URLImage: View {
    let url: URL?
    @StateObject private var loader = ImageLoader()

    var body: some View {
        content
            .onAppear {
                loader.load(from: url)
            }
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray.opacity(0.3) // Placeholder
            }
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func load(from url: URL?) {
        guard let url = url else { return }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.image = $0 }
    }

    deinit {
        cancellable?.cancel()
    }
}
