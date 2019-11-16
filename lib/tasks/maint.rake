
namespace :maint do
  desc "古いBellを削除"
  task :cleanup do
    # asyncでActionCable使ってると別プロセスからbroadcastできないので
    # Controllerにメンテ用API作ってそれを叩く
    uri = if Rails.env == 'production'
      'http://localhost/bells/cleanup'
    else
      'http://localhost:3000/bells/cleanup'
    end
    Net::HTTP.get(URI.parse(uri))
  end
end
