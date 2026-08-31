# RestaurantTamer

Vertical slice untuk 10-Day Foundation Challenge, Apple Developer Academy Cohort 9.
Loop: **Feeding Loop + Grill Minigame**, dipotong dari game concept lebih besar "Restaurant Tamer (RestMe)".

## Scope

Spec lengkap ada di [docs/PRD.md](docs/PRD.md) — baca itu dulu sebelum nambah fitur apa pun.

**Kerjakan HANYA:**
- 1 scene resto, 1 makhluk placeholder (bentuk simpel, bukan art final)
- Feeding loop: timer → bubble muncul → tap → Grill minigame → grade → cooldown
- Grill minigame: progress bar 0→100% otomatis, zona hijau, tap buat grading (Perfect/Good/Low)

**JANGAN implementasikan** (sengaja di luar scope slice ini, walau ada di GDD besar Restaurant Tamer):
pantry/resource system, multi-stasiun assembly, sistem Boss, breeding/telur, exploration, multi-makhluk, navigasi antar-screen, art/audio final.

Kalau kepikiran "enaknya nambah X" — cek dulu ke daftar di atas / Bagian 5 PRD. Kalau X ada di situ, itu sengaja belum, bukan lupa.

## Arsitektur — MVVM, wajib

```
RestaurantTamer/
├── Models/       — data & pure logic: GameConfig, enum Grade/FeedingState, kalkulasi grading
├── ViewModels/   — state machine & game logic (timer, bubble trigger, minigame flow).
│                   TIDAK import SpriteKit, tidak pegang SKNode — cuma expose state & keputusan.
└── Views/        — SpriteKit scene & node (GameScene, CreatureNode, BubbleNode).
                    Cuma render & forward input ke ViewModel, tanpa logic keputusan di dalamnya.
```

Aturan pemisahan: **Model** = data murni, nggak tau apa-apa soal View/ViewModel. **ViewModel** = otak (state, timer, keputusan grade), nggak boleh `import SpriteKit`. **View** = SpriteKit node/scene, cuma nampilin state dari ViewModel & terusin touch event — nggak boleh ada keputusan logic di file `Views/`.

Ini juga yang direpresentasikan ke fokus "Game Logic and State" di PRD — pemisahan ViewModel dari View HARUS kelihatan jelas, bukan campur dalam satu file.

## Kode & komentar

- Clean code: nama jelas, fungsi kecil, tanpa abstraksi yang belum kepake.
- Tanpa AI slop di komentar — nggak ada decorative separator/banner, nggak restate kode yang udah jelas dari namanya, nggak ada emoji dekoratif, nggak ada TODO vague. Komentar cuma buat WHY yang nggak kelihatan dari kode (keputusan desain, workaround, constraint) — lihat skill `antislop-code` kalau ragu.

## Dokumentasi

Semua file `.md` project ini ada di `docs/` — **local-only, jangan dipush ke GitHub** (ada di `.gitignore`). Jangan taruh markdown baru di root (`CLAUDE.md` sendiri pengecualian, karena itu konvensi Claude Code).

## Git

Commit/push atas nama Rahmandhika saja — jangan pernah tambah trailer `Co-Authored-By: Claude` atau atribusi AI apa pun.

## Parameter

Semua nilai tunable ada di `Models/GameConfig.swift`. Pakai nilai dev/testing (satuan detik, bukan menit) selama development — lihat tabel Bagian 6 PRD buat nilai final sebelum demo.

## Konteks proyek

Ini proyek belajar/portofolio, bukan production code — utamakan kejelasan & idiomatic SpriteKit dibanding trik rumit. Progress harian & keputusan parameter dicatat di [docs/PROGRESS.md](docs/PROGRESS.md).
