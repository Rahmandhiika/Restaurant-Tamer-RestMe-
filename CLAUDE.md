# RestMe

Vertical slice untuk 10-Day Foundation Challenge, Apple Developer Academy Cohort 9.
Loop: **Feeding Loop + Grill Minigame**, dipotong dari game concept lebih besar "Restaurant Tamer (RestMe)".

Ini project Xcode baru (Day 3+), gantiin project lama `RestaurantTamer` yang masih pakai template Game — pindah ke template App (SwiftUI) atas arahan mentor. Riwayat keputusan lengkap dari Day 1-3 ada di `docs/PROGRESS.md`.

## Scope

Spec lengkap ada di [docs/PRD.md](docs/PRD.md) — baca itu dulu sebelum nambah fitur apa pun.

**Kerjakan HANYA (desain final Day 3):**
- 1 scene resto, 1 makhluk (sprite `Creature`, bukan placeholder shape lagi)
- Feeding loop: timer → indikator lapar + 4 dispenser (plate/bun/isian/raw meat) muncul
- Dispenser permanen — drag menghasilkan salinan, sumber nggak pernah habis
- Assembly: plate wajib ditaro di area serve duluan, baru bun/isian/meat (urutan bebas setelahnya)
- Raw meat wajib mampir Pan dulu — satu-satunya titik skill-check (progress bar otomatis, zona hijau, drag-off buat grading Perfect/Good/Low)
- Meat gosong wajib dibuang ke Trash, dispenser tetap ada (retry gratis)
- Piring lengkap (plate+bun+isian+meat) → 1 objek gabungan → drag ke makhluk buat serve
- Timeout 35 detik kalau 1 siklus kelamaan nggak diselesain

**JANGAN implementasikan** (sengaja di luar scope slice ini, walau ada di GDD besar Restaurant Tamer):
pilihan/inventory antar banyak jenis bahan (tetap 1 resep fixed, cuma dirakit 4 bagian — bukan sistem pantry beneran), sistem Boss, breeding/telur, exploration, multi-makhluk sekaligus, navigasi antar-screen, art/audio final.

Kalau kepikiran "enaknya nambah X" — cek dulu ke daftar di atas / Bagian 5 PRD. Kalau X ada di situ, itu sengaja belum, bukan lupa.

## Arsitektur — MVVM, wajib

```
RestMe/
├── Models/       — data & pure logic: GameConfig, enum Grade/FeedingState, kalkulasi grading
├── ViewModels/   — state machine & game logic (timer, dispenser, assembly, minigame flow).
│                   TIDAK import SpriteKit, tidak pegang SKNode — cuma expose state & keputusan.
└── Views/        — SwiftUI shell (ContentView + SpriteView) & SpriteKit scene/node
                    (GameScene, CreatureNode, dispenser/Pan/Trash/Piring node).
                    Cuma render & forward input ke ViewModel, tanpa logic keputusan di dalamnya.
```

- **Shell aplikasi:** SwiftUI (`RestMeApp.swift` → `ContentView`). `ContentView` nampung `SpriteView(scene:)` yang isinya `GameScene` — SpriteKit tetap yang pegang scene/node/drag-logic, SwiftUI cuma wadahnya.
- **Model** = data murni, nggak tau apa-apa soal View/ViewModel.
- **ViewModel** = otak (state, timer, keputusan grade, tracking komponen assembly), nggak boleh `import SpriteKit`.
- **View** = SwiftUI + SpriteKit node/scene, cuma nampilin state dari ViewModel & terusin touch/drag event — nggak boleh ada keputusan logic di file `Views/`.

Ini yang direpresentasikan ke fokus "Game Logic and State" di PRD — pemisahan ViewModel dari View HARUS kelihatan jelas, bukan campur dalam satu file.

## Kode & komentar

- Clean code: nama jelas, fungsi kecil, tanpa abstraksi yang belum kepake.
- Tanpa AI slop di komentar — nggak ada decorative separator/banner, nggak restate kode yang udah jelas dari namanya, nggak ada emoji dekoratif, nggak ada TODO vague. Komentar cuma buat WHY yang nggak kelihatan dari kode (keputusan desain, workaround, constraint) — lihat skill `antislop-code` kalau ragu.

## Aset

Detail lengkap mapping aset (file mana buat apa) ada di `docs/PROGRESS.md` bagian "Referensi Aset". Semua sumber PNG ada di `~/Downloads/Asset Challenge 6/` (sudah diexport & digroupin per kategori) — pindahin ke `Assets.xcassets` sesuai kebutuhan, jangan import semuanya kalau belum kepake.

## Dokumentasi

Semua file `.md` project ini ada di `docs/` — **local-only, jangan dipush ke GitHub** kalau/pas repo ini di-git-init (tambahin ke `.gitignore`). Jangan taruh markdown baru di root (`CLAUDE.md` sendiri pengecualian, karena itu konvensi Claude Code).

## Git

Repo ini belum di-git-init — kalau mau, init & push atas nama Rahmandhika saja, jangan pernah tambah trailer `Co-Authored-By: Claude` atau atribusi AI apa pun.

## Parameter

Semua nilai tunable ada di `Models/GameConfig.swift`. Pakai nilai dev/testing (satuan detik, bukan menit) selama development — lihat tabel Bagian 6 PRD buat nilai final sebelum demo.

## Konteks proyek

Ini proyek belajar/portofolio, bukan production code — utamakan kejelasan & idiomatic SpriteKit/SwiftUI dibanding trik rumit. Progress harian & keputusan parameter dicatat di [docs/PROGRESS.md](docs/PROGRESS.md).
