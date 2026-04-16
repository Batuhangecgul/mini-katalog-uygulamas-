# Mini Katalog Uygulamasi

Flutter haftalik egitim cikti projesi: ana sayfa, urun listesi, urun detayi, route argument gecisi, GridView kartlar ve basit sepet state simulasyonu.

## Kisa Aciklama

Bu uygulama temel Flutter egitim hedeflerini gostermek icin hazirlanmistir:

- Stateless ve Stateful widget kullanimi
- Temel UI bilesenleri (Text, Container, Row, Column, Card, ListTile mantigi)
- Navigator ile sayfalar arasi gecis
- Named route ve route argument ile veri tasima
- JSON simulasyonu ile modelleme (fromJson/toJson)
- GridView ile urun kartlari
- Basit arama ve filtreleme
- Sepete ekleme simulasyonu

## Kullanilan Flutter Surumu

- Flutter: 3.41.6 (stable)
- Dart: 3.11.4

## Kurulum ve Calistirma Adimlari

1. Flutter kurulumunu dogrulayin:

	 ```bash
	 flutter doctor
	 ```

2. Proje bagimliliklarini yukleyin:

	 ```bash
	 flutter pub get
	 ```

3. Emulatorde veya fiziksel cihazda uygulamayi calistirin:

	 ```bash
	 flutter run
	 ```

## Proje Yapisı

```text
lib/
	models/
		product.dart
	screens/
		home_screen.dart
		product_detail_screen.dart
	services/
		product_repository.dart
	widgets/
		product_card.dart
	main.dart
assets/
	data/
		products.json
screenshots/
	.gitkeep
```

## Egitim Amacli Veri Kaynaklari

- Banner gorseli: https://wantapi.com/assets/banner.png
- Urun verisi mantigi: https://wantapi.com/products.php

Not: Uygulama, egitim kapsaminda ekstra paket kullanmadan yerel JSON simulasyonu ile calismaktadir.

## Ekran Goruntuleri

Ekran goruntulerini `screenshots/` klasorune ekleyebilirsiniz.
