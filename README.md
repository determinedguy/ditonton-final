# Ditonton

[![Automatic Testing](https://github.com/determinedguy/ditonton-final/actions/workflows/test.yml/badge.svg)](https://github.com/determinedguy/ditonton-final/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/determinedguy/ditonton-final/branch/main/graph/badge.svg?token=k9rxS3APnu)](https://codecov.io/gh/determinedguy/ditonton-final)

Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.

> Proyek ini dikerjakan oleh Muhammad Athallah.

## Kriteria Wajib

- [x] Menerapkan Continuous Integration
    - [x] Menjalankan pengujian aplikasi secara otomatis. Semua pengujian harus tetap terpenuhi dan mempertahankan fitur dari submission sebelumnya.
    - [x] Dijalankan setiap ada push kode terbaru ke dalam repository.
    - [x] Anda perlu mengunggah kode ke dalam GitHub repository milik Anda sendiri lalu mencantumkan tautannya sebagai catatan (pastikan repository yang digunakan adalah repository public).
    - [x] Menampilkan build status badge pada berkas readme repository GitHub.
    - [x] Melampirkan [screenshot salah satu build dari CI service](screenshots/success_build.png) (GitHub Actions).
    - [x] Anda bebas menggunakan layanan CI apa pun untuk submission (GitHub Actions).
- [ ] Menggunakan Library BLoC
    - [ ] Melakukan migrasi state management yang sebelumnya menggunakan provider menjadi BLoC.
- [x] Menerapkan SSL Pinning
    - [x] Memasang sertifikat SSL pada aplikasi sebagai lapisan keamanan tambahan untuk mengakses data dari API.
- [x] Integrasi dengan Firebase Analytics & Crashlytics
    - [x] Memastikan developer tetap mendapat feedback dari pengguna, khususnya terkait stabilitas dan laporan eror.
    - [x] Ditunjukkan dengan screenshot halaman [Analytics](screenshots/analytics.png) dan [Crashlytics](screenshots/crashlytics.png).

## Kriteria Opsional

- [ ] Modularisasi
    - [ ] Membagi aplikasi menjadi modul setidaknya untuk dua fitur movie & TV series.

## Referensi

Berikut adalah referensi yang digunakan untuk menyelesaikan proyek ini.

- [Run Flutter tests using GitHub Actions and Codecov](https://damienaicheh.github.io/flutter/github/actions/2021/05/06/flutter-tests-github-actions-codecov-en.html)
- [How to get your "actual" test coverage of your Flutter applications?](https://medium.com/flutter-community/how-to-actually-get-test-coverage-for-your-flutter-applications-f881c0ae8155)