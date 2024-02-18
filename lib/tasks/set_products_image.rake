namespace :products do
  desc "Attach images to products from image_url"
  task assign_images: :environment do
    Product.find_each do |product|
      unless product.image.attached? # How avoid database call inside loop?
        file_path = Rails.root.join('app', 'assets', 'images', product.image_url)
        product.image.attach(
                              io: File.open(file_path),
                              filename: product.image_url
                            )
      end
    end
  end
end
