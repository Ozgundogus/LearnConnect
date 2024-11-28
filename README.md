# LearnConnect 

LearnConnect, kullanıcıların video tabanlı eğitim içeriklerine erişebileceği, kişiselleştirilmiş öğrenme deneyimi sunan modern bir iOS uygulamasıdır.

[📱 Demo Videosu İzle](https://www.youtube.com/watch?v=Qa8hX0Zbqn4)

## 🌟 Özellikler

### 📱 Kullanıcı Arayüzü
- Modern ve kullanıcı dostu tasarım
- Karanlık/Aydınlık tema desteği
- Özelleştirilmiş tab bar navigasyonu
- Akıcı animasyonlar ve geçişler
- Responsive layout tasarımı

### 🔐 Kimlik Doğrulama
- Kullanıcı kaydı ve girişi
- Core Data ile güvenli veri saklama
- Oturum yönetimi
- Şifre görünürlük kontrolü

### 🏠 Ana Sayfa
- Kategorize edilmiş içerik gösterimi
  - Spor
  - Seyahat
  - Yaşam Tarzı
  - Eğitim
  - Doğa
- Banner slider
- Özelleştirilmiş koleksiyon görünümleri
- Arama fonksiyonu

### 📚 İçerik Yönetimi
- Video oynatma
- İçerik indirme
- Yer imleri ekleme
- Kategori bazlı filtreleme
- YouTube entegrasyonu

### 🔔 Bildirim Sistemi
- Push bildirimleri (3 dakikada bir)
- Bildirim yönetimi
- Uygulama ikonu rozet sayısı
- Özelleştirilmiş bildirim mesajları:
  - "Spor kategorisindeki kursları incelemek ister misiniz?"
  - "Eğitim kategorisindeki kursları incelemek ister misiniz?"
  - "Doğa kategorisindeki kursları incelemek ister misiniz?"
  - "Gezi kategorisindeki kursları incelemek ister misiniz?"
  - "LifeStyle kategorisindeki kursları incelemek ister misiniz?"

### 🎯 Toast Bildirimleri
Aşağıdaki durumlarda toast bildirimleri gösterilir:
- Başarılı giriş/kayıt işlemleri
- Hatalı giriş denemeleri
- Video indirme işlemleri
- Yer imi ekleme işlemleri
- Hata durumları

Toast özellikleri:
- 2 saniye görüntülenme süresi
- Yumuşak animasyonlar
- Durum bazlı renk kodlaması (başarı: yeşil, hata: kırmızı)
- Ekranın üst kısmında gösterim

## 🔄 Bildirim Detayları
- Bildirimler 3 dakikalık aralıklarla gönderilir
- Her bildirim farklı bir kategori için gönderilir
- Bildirime tıklandığında ilgili kategori sayfasına yönlendirilir
- Uygulama ikonu üzerinde okunmamış bildirim sayısı gösterilir
- Bildirim geldiğinde:
  - Banner gösterimi
  - Ses efekti
  - Titreşim
  - Rozet sayısı güncelleme

## 🛠 Teknik Özellikler
- Swift programlama dili
- UIKit framework
- MVVM mimari pattern
- Core Data veritabanı
- UserDefaults kullanımı
- Custom view controllers
- Delegate pattern implementasyonu
- Notification Center kullanımı
- YouTube API entegrasyonu

## 🎨 Tema Desteği
- Sistem temasına otomatik uyum
- Özelleştirilmiş renk paleti
- Dynamic Type desteği
- Accessibility uyumlu tasarım

## 💾 Veri Saklama
- Core Data ile yerel veritabanı
- UserDefaults ile kullanıcı tercihleri
- Güvenli şifre saklama
- Çevrimdışı içerik erişimi

## 🔍 Arama Özellikleri
- Gerçek zamanlı arama
- Kategori bazlı filtreleme
- Geçmiş aramaları saklama
- Önerilen aramalar

## 📊 Performans
- Lazy loading implementasyonu
- Önbellek mekanizması
- Optimize edilmiş görsel yükleme
- Minimum bellek kullanımı

## 🌐 Network
- RESTful API entegrasyonu
- YouTube Data API kullanımı
- Offline mod desteği
- Bağlantı durumu kontrolü