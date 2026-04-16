# Mini Katalog Uygulamasi

Flutter egitimi kapsaminda gelistirilen mini katalog uygulamasi.

## Repository Bilgisi

- Repository URL: BURAYA_GITHUB_REPOSITORY_URL_YAZIN
- Repository durumu: Public olmali
- Proje durumu: Calisir durumda (README dahil)

## Kisa Aciklama

Uygulama, Fake Store API uzerinden urunleri cekip kullaniciya katalog deneyimi sunar.
Temel ozellikler:

- Ana sayfada urunleri grid olarak listeleme
- Arama ve kategoriye gore filtreleme
- Urun detay sayfasi ve route argument gecisi
- Sepete urun ekleme, adet arttirma/azaltma, urun cikarma
- Adet 0 oldugunda urunu sepette aninda gizleme

## Kullanilan Flutter Surumu

- Flutter: 3.41.6 (stable)
- Dart: 3.11.4

## Calistirma Adimlari

1. Flutter kurulumunu dogrulayin.

```bash
flutter doctor
```

2. Proje bagimliliklarini yukleyin.

```bash
flutter pub get
```

3. Uygulamayi emulator veya fiziksel cihazda calistirin.

```bash
flutter run
```

4. (Opsiyonel) Android icin APK alin.

```bash
flutter build apk --split-per-abi
```

## Ekran Goruntuleri (screenshots)

Asagidaki ekran goruntuleri `screenshots/` klasoru altina eklenmelidir:

- `screenshots/home.png`
- `screenshots/category-filter.png`
- `screenshots/product-detail.png`
- `screenshots/cart.png`

Not: Su anda `screenshots/` klasorunde yalnizca `.gitkeep` bulunuyor. Teslim oncesi gercek ekran goruntulerini ekleyin.
